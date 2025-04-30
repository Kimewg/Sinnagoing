import UIKit
import SnapKit
import CoreData

class MyPageVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
    
    var rentalHistory: [String] = ["여기는 빌렸던 킥보드에용","울트라캡숑간지킥보드", "타락파워킥보드", "앞에 비켜라 지나간다 킥볻"]
    
    var myRegisteredBoards: [String] = ["여기는 등록한 킥보드에용","울트라캡숑간지킥보드", "타락파워킥보드" , "T없이 맑은 킥보드"]
    
    
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
        //        imageView.image = imageForUseBoard(isRental)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var userLabel: UILabel = {
        let label = UILabel()
        
        // UserDefaults에서 "users" 배열을 불러온 후 마지막 사용자의 이름을 가져옴
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
        debugKickboardData()
        reloadInputViews()
        useTableView.register(KickboardTableViewCell.self, forCellReuseIdentifier: KickboardTableViewCell.identifier)
        addBoardTableView.register(KickboardTableViewCell.self, forCellReuseIdentifier: KickboardTableViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImageBasedOnRentalStatus()
        fetchData()
    }
    
    private func fetchData() {
        // KickboardEntity에 대한 FetchRequest 생성
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        // 조건걸어주기(isRentaled이 false인 데이터만)
        // Core Data는 Bool 타입 필터링할 때 NSNumber로 변환해야한다(Swift에서는 true/false지만, 내부적으로 NSNumber를 쓰기때문)
        fetchRequest.predicate = NSPredicate(format: "isRentaled == %@", NSNumber(value: false))
    }
    
    @objc func logoutTapped() {
        let loginVC = LoginVC()
        let navVC = UINavigationController(rootViewController: loginVC)

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
    }
    func configure() {
        [
            myPageLabel,
            separator,
            usingView,
            boardBreakDown, // <- 테이블뷰보다 위에 추가
            useTableView,
            addBoardList,   // <- 테이블뷰보다 위에 추가
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
        
        // boardBreakDown (킥보드 이용내역 제목)
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
        
        // addBoardList (내가 등록한 킥보드 제목)
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
    
    func debugKickboardData() {
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        
        do {
            let kickboards = try context.fetch(fetchRequest)
            print("전체 킥보드 수: \(kickboards.count)")
            for board in kickboards {
                print("board.id: \(board.objectID), isRentaled: \(board.isRentaled)")
            }
        } catch {
            print("전체 fetch 실패: \(error)")
        }
    }
    func updateImageBasedOnRentalStatus() {
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isRentaled == true")
        
        do {
            let rentedKickboards = try context.fetch(fetchRequest)
            print("가져온 킥보드 수: \(rentedKickboards.count)")
            for board in rentedKickboards {
                print("킥보드 상태 isRentaled: \(board.isRentaled)")
            }
            
            let imageName = rentedKickboards.isEmpty ? "horse2" : "horse"
            DispatchQueue.main.async {
                self.useImageView.image = UIImage(named: imageName)
                print("이미지 적용됨: \(imageName)")
                
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
}
extension MyPageVC: UITableViewDataSource {
    //섹션 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == useTableView {
            return rentalHistory.count
        } else {
            return myRegisteredBoards.count
        }
    }
    //셀안의 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KickboardTableViewCell.identifier, for: indexPath) as? KickboardTableViewCell else {
                return UITableViewCell()
            }

            let text = tableView == useTableView ? rentalHistory[indexPath.row] : myRegisteredBoards[indexPath.row]
            cell.contentLabel.text = text
            return cell
    }
}
//섹션의 높이
extension MyPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
