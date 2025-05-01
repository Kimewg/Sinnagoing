import UIKit
import SnapKit
import CoreData
import CoreLocation
class MyPageVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
    var rentalHistory: [String] = [] // Core Data에서 가져올 렌탈 킥보드 목록
    var myRegisteredBoards: [String] = [] // Core Data에서 가져올 등록된 킥보드 목록
    var myPageLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "CFC8C8")
        return separator
    }()
    var usingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F5F5F5")
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var useImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var userLabel: UILabel = {
        let label = UILabel()
        // currentUserName을 가져와서 사용자 이름을 표시
        if let name = UserDefaults.standard.string(forKey: "currentUserName") {
          label.text = "\(name)님,"
        } else {
          label.text = "사용자님,"
        }
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
      }()

    var boardConditions: UILabel = {
        let label = UILabel()
        label.text = "천마논과 안전운전 하세요!"
        label.textColor = UIColor(hex: "915B5B")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    var useTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(hex: "#F5F5F5")
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    var addBoardTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(hex: "#F5F5F5")
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    var logout: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor(hex: "868383"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F5F5F5")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        return button
    }()
    var boardBreakDown: UILabel = {
        let label = UILabel()
        label.text = "킥보드 이용내역"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    var addBoardList: UILabel = {
        let label = UILabel()
        label.text = "내가 등록한 킥보드"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        useTableView.delegate = self
        useTableView.dataSource = self
        addBoardTableView.delegate = self
        addBoardTableView.dataSource = self
        logout.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        configure()
        reloadInputViews()
        useTableView.register(KickboardTableViewCell.self, forCellReuseIdentifier: KickboardTableViewCell.identifier)
        addBoardTableView.register(KickboardTableViewCell.self, forCellReuseIdentifier: KickboardTableViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rentalHistory = fetchRentalHistory()
        useTableView.reloadData()

        fetchMyRegisteredBoards { boards in
            self.myRegisteredBoards = boards
            self.addBoardTableView.reloadData()
        }

        updateImageBasedOnRentalStatus()
    }

    func fetchRentalHistory() -> [String] {
        guard let userID = UserDefaults.standard.string(forKey: "currentUserID") else {
            return []
        }

        let fetchRequest: NSFetchRequest<RentalHistoryEntity> = RentalHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rentalDate", ascending: false)]

        do {
            let rentedKickboards = try context.fetch(fetchRequest)
            return rentedKickboards.compactMap { rental in
                guard let start = rental.rentalDate, let end = rental.returnDate else { return nil }

                let dateStr = formatDateWithDayOfWeek(start)
                let timeRange = formatRentalTimeRange(from: start, to: end)
                let duration = calculateUsageDuration(from: start, to: end)
                let price = calculateTotalCharge(from: start, to: end)

                return "\(dateStr)\n\(timeRange) | \(duration) | \(formatPrice(price))"
            }
        } catch {
            print("렌탈 히스토리 가져오기 실패: \(error)")
            return []
        }
    }

    // 수정된 fetchMyRegisteredBoards 함수
    func fetchMyRegisteredBoards(completion: @escaping ([String]) -> Void) {
        guard let userID = UserDefaults.standard.string(forKey: "currentUserID") else {
            completion([])
            return
        }
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        DispatchQueue.global().async {
            var boardDescriptions: [String] = []
            let group = DispatchGroup()
            do {
                let registeredKickboards = try self.context.fetch(fetchRequest)
                for kickboard in registeredKickboards {
                    let location = CLLocation(latitude: kickboard.latitude, longitude: kickboard.longitude)
                    group.enter()
                    self.locationToAddress(location: location) { address in
                        let addressText = address ?? "주소 정보 없음"
                        let secondLine = "배터리 잔량: \(kickboard.battery)% | 대여 횟수: \(kickboard.rentalCount)회"
                        boardDescriptions.append("\(addressText)\n\(secondLine)")
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(boardDescriptions)
                }
            } catch {
                print("킥보드 가져오기 실패: \(error)")
                completion([])
            }
        }
    }
    func locationToAddress(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("주소 변환 오류: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let placemark = placemarks?.first {
                var addressParts: [String] = []
                if let administrativeArea = placemark.administrativeArea {
                    addressParts.append(administrativeArea) // 예: 경상북도
                }
                if let locality = placemark.locality {
                    addressParts.append(locality) // 예: 경주시
                }
                if let thoroughfare = placemark.thoroughfare {
                    addressParts.append(thoroughfare) // 예: 경주대로
                }
                if let subThoroughfare = placemark.subThoroughfare {
                    addressParts.append(subThoroughfare) // 예: 800
                }
                let filteredAddress = addressParts
                    .compactMap { $0 }
                    .joined(separator: " ")
                completion(filteredAddress)
            } else {
                completion(nil)
            }
        }
    }
    @objc func logoutTapped() {
        if RentalManager.shared.checkUserIsRenting() {
            let alert = UIAlertController(title: "다메다메", message: "킥보드 돌려주고 가셈", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in })
            self.present(alert, animated: true)
        }
        else {
              UserDefaults.standard.removeObject(forKey: "currentUserID")
                  UserDefaults.standard.synchronize()
              let loginVC = LoginVC()
              let navVC = UINavigationController(rootViewController: loginVC)
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
              if let window = windowScene?.windows.first {
                window.rootViewController = navVC
                window.makeKeyAndVisible()
              }
            }
          }
        func configure() {
            [
                myPageLabel,
                separator,
                usingView,
                boardBreakDown,
                useTableView,
                addBoardList,
                addBoardTableView,
                logout,
            ].forEach { view.addSubview($0) }
            [useImageView, userLabel, boardConditions].forEach { usingView.addSubview($0) }
            // MyPage Title
            myPageLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(63)
                make.centerX.equalToSuperview()
            }
            // Separator
            separator.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(98)
                make.leading.trailing.equalToSuperview().inset(1)
                make.height.equalTo(1)
            }
            // Using View
            usingView.snp.makeConstraints { make in
                make.top.equalTo(separator.snp.bottom).offset(34)
                make.leading.trailing.equalToSuperview().inset(42)
                make.height.equalTo(84)
            }
            useImageView.snp.makeConstraints { make in
                make.size.equalTo(81)
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
            userLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalToSuperview().offset(15)
            }
            boardConditions.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().inset(23)
            }
            // boardBreakDown
            boardBreakDown.snp.makeConstraints { make in
                make.top.equalTo(usingView.snp.bottom).offset(29)
                make.leading.equalToSuperview().offset(46)
                make.height.equalTo(22)
            }
            // useTableView
            useTableView.snp.makeConstraints { make in
                make.top.equalTo(boardBreakDown.snp.bottom).offset(5)
                make.leading.trailing.equalToSuperview().inset(42)
                make.height.equalTo(169)
            }
            // addBoardList
            addBoardList.snp.makeConstraints { make in
                make.top.equalTo(useTableView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(46)
                make.height.equalTo(22)
            }
            // addBoardTableView
            addBoardTableView.snp.makeConstraints { make in
                make.top.equalTo(addBoardList.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(42)
                make.height.equalTo(169)
            }
            // logout
            logout.snp.makeConstraints { make in
                make.top.equalTo(addBoardTableView.snp.bottom).offset(52)
                make.centerX.equalToSuperview()
                make.width.equalTo(128)
                make.height.equalTo(33)
            }
            useTableView.separatorStyle = .none
            useTableView.rowHeight = UITableView.automaticDimension
            useTableView.estimatedRowHeight = 60
            useTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
            addBoardTableView.separatorStyle = .none
            addBoardTableView.rowHeight = UITableView.automaticDimension
            addBoardTableView.estimatedRowHeight = 60
            addBoardTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
        
        }
        func updateImageBasedOnRentalStatus() {
            let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isRentaled == true")
            do {
                let rentedKickboards = try context.fetch(fetchRequest)
                let imageName = rentedKickboards.isEmpty ? "horse2" : "horse"
                DispatchQueue.main.async {
                    self.useImageView.image = UIImage(named: imageName)
                    if rentedKickboards.isEmpty {
                        self.boardConditions.text = "킥보드 타기 좋은 날씨에요!"
                    } else {
                        self.boardConditions.text = "천마논과 안전운전 하세요!"
                    }
                }
            } catch {
                print("CoreData fetch 실패: \(error)")
            }
        }
        // 날짜를 원하는 형식으로 변환하는 함수
    func formatDateWithDayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = formatter.string(from: date)

        // 요일 추출 (한글 요일)
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
        let weekdayString = weekDays[weekday - 1] // 1 = 일요일, 7 = 토요일

        return "\(dateString) (\(weekdayString))"
    }
        // 렌탈 시간과 반납 시간 차이를 계산하는 함수
    func formatRentalTimeRange(from startDate: Date, to endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startTimeString = formatter.string(from: startDate)
        let endTimeString = formatter.string(from: endDate)

        return "\(startTimeString) ~ \(endTimeString)"
    }
    func calculateUsageDuration(from startDate: Date, to endDate: Date) -> String {
        let interval = Int(endDate.timeIntervalSince(startDate))
        let minutes = interval / 60
        return String(format: "%02d분", minutes) // "00분" 형태로 반환
    }
    func calculateTotalCharge(from startDate: Date, to endDate: Date) -> Int {
        let rentalDuration = endDate.timeIntervalSince(startDate) // 초 단위
        let durationInMinutes = Int(ceil(rentalDuration / 60)) // 올림 처리해서 1분 단위로 요금 청구
        let totalCharge = durationInMinutes * 100 // 분당 100원
        return totalCharge
    }
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        return "\(formattedPrice)원"
    }
    }
    extension MyPageVC: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == useTableView {
                return rentalHistory.count
            } else {
                return myRegisteredBoards.count
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: KickboardTableViewCell.identifier, for: indexPath) as? KickboardTableViewCell else {
                return UITableViewCell()
            }
            let text = tableView == useTableView ? rentalHistory[indexPath.row] : myRegisteredBoards[indexPath.row]
            cell.contentLabel.text = text
            cell.contentLabel.numberOfLines = 0
            return cell
        }
    }
    extension MyPageVC: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
