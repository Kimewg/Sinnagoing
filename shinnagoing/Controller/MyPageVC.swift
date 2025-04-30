import UIKit
import SnapKit

class MyPageVC: UIViewController {
    
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
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "horse")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var userLabel: UILabel = {
        let label = UILabel()
        label.text = "최영락님,"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var boardConditions: UILabel = {
        let label = UILabel()
        label.text = "현재 킥보드                   입니다."
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var boardConditions2: UILabel = {
        let label = UILabel()
        label.text = "이용중"
        label.textColor = UIColor(hex: "915B5B")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var useTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(hex: "#F5F5F5")
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    var addBoardTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(hex: "#F5F5F5")
        tableView.layer.cornerRadius = 10
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
        logout.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        configure()
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
            logout
        ].forEach { view.addSubview($0) }
        
        [imageView, userLabel, boardConditions, boardConditions2].forEach { usingView.addSubview($0) }
        
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
            make.top.equalTo(separator.snp.bottom).offset(34) // ← 깔끔하게 separator 기준
            make.leading.trailing.equalToSuperview().inset(42)
            make.height.equalTo(84)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(81)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview() // 이거 추가
        }
        
        userLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(15)
        }
        
        boardConditions.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().inset(26)
        }
        
        boardConditions2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(80)
            make.bottom.equalToSuperview().inset(26)
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
    }
}


extension MyPageVC: UITableViewDataSource {
    //섹션 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    //셀안의 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
//섹션의 높이
extension MyPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        0
    }
}
