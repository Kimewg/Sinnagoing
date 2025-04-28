import UIKit
import SnapKit

class MyPageVC: UIViewController {
    
    var usingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F5F5F5")
        view.layer.cornerRadius = 10
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kickBoard")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var userLabel: UILabel = {
        let label = UILabel()
        label.text = "[유저아이디]님,"
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
        label.textColor = UIColor(hex: "#C89F43")
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
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    var boardBraekDown: UILabel = {
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
        navigationBarItem()
        configure()
    }
    func navigationBarItem() {
        self.title = "마이페이지"
    }
    
    func configure() {
        [usingView,
         useTableView,
         addBoardTableView
        ].forEach{ view.addSubview($0) }
        
        [imageView,
         userLabel,
         boardConditions,
         boardConditions2,
         logout
        ].forEach { usingView.addSubview($0)}
        
        addBoardTableView.addSubview(addBoardList)
        useTableView.addSubview(boardBraekDown)
        
        usingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(132)
            make.trailing.leading.equalToSuperview().inset(42)
            make.height.equalTo(84)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.trailing.equalToSuperview().inset(16)
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
            make.bottom.equalToSuperview().inset(26)
            make.leading.equalToSuperview().offset(80)
        }
        useTableView.snp.makeConstraints { make in
            make.top.equalTo(usingView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(42)
            make.height.equalTo(144)
        }
        addBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(useTableView.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(42)
            make.height.equalTo(144)
        }
        logout.snp.makeConstraints{ make in
            make.width.equalTo(322)
            make.height.equalTo(39)
            make.top.equalTo(addBoardTableView.snp.bottom).offset(52)
        }
        addBoardList.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(17)
        }
        boardBraekDown.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(17)
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
