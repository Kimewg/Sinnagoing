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
        if let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]],
           let lastUser = users.last,
           let name = lastUser["name"] {
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
        // Core Data에서 데이터를 가져옵니다.
        rentalHistory = fetchRentalHistory() // 렌탈된 킥보드 데이터
        myRegisteredBoards = fetchMyRegisteredBoards() // 등록된 킥보드 데이터
        // 테이블 뷰 리로드
        useTableView.reloadData()
        addBoardTableView.reloadData()
        updateImageBasedOnRentalStatus()
    }
    func fetchRentalHistory() -> [String] {
      guard let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]],
            let lastUser = users.last,
            let userID = lastUser["name"] else {
        return []
      }

      let fetchRequest: NSFetchRequest<RentalHistoryEntity> = RentalHistoryEntity.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rentalDate", ascending: false)] // 최신순 정렬

      do {
        let rentedKickboards = try context.fetch(fetchRequest)
        return rentedKickboards.compactMap { rentalHistory in
          guard let rentalDate = rentalHistory.rentalDate else {
            return nil
          }
          let rentalDateString = formatDate(rentalDate)
          if let returnDate = rentalHistory.returnDate {
            let duration = calculateUsageDuration(from: rentalDate, to: returnDate)
            return "\(rentalDateString) - 이용 시간: \(duration)"
          } else {
            return "\(rentalDateString) - 이용 중"
          }
        }
      } catch {
        print("렌탈된 킥보드 데이터 가져오기 실패: \(error)")
        return []
      }
    }
    // 수정된 fetchMyRegisteredBoards 함수
    func fetchMyRegisteredBoards() -> [String] {
        guard let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]],
              let lastUser = users.last,
              let userID = lastUser["name"] else {
            return []
        }
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        var boardDescriptions: [String] = []
        let group = DispatchGroup()
        do {
            let registeredKickboards = try context.fetch(fetchRequest)
            for kickboard in registeredKickboards {
                let latitude = kickboard.latitude
                let longitude = kickboard.longitude
                let location = CLLocation(latitude: latitude, longitude: longitude)
                group.enter()
                locationToAddress(location: location) { address in
                    let addressText = address ?? "주소 정보 없음"
                    let description = "위도: \(latitude), 경도: \(longitude), 주소: \(addressText)"
                    boardDescriptions.append(description)
                    group.leave()
                }
            }
            group.wait() // 비동기 주소 변환이 끝날 때까지 대기
        } catch {
            print("등록된 킥보드 데이터 가져오기 실패: \(error)")
        }
        return boardDescriptions
    }

    func locationToAddress(location: CLLocation, completion: @escaping (String?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("주소 변환 오류: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let placemark = placemarks?.first, let address = placemark.thoroughfare {
                    completion(address) // 주소 반환
                } else {
                    completion(nil) // 주소 변환 실패
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
        func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식으로 변경 가능
            return dateFormatter.string(from: date)
        }
        // 렌탈 시간과 반납 시간 차이를 계산하는 함수
        func calculateUsageDuration(from rentalDate: Date, to returnDate: Date) -> String {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: rentalDate, to: returnDate)
            guard let hour = components.hour, let minute = components.minute, let second = components.second else {
                return "계산 오류"
            }
            return String(format: "%02d:%02d:%02d", hour, minute, second)
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
            return cell
        }
    }
    extension MyPageVC: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
