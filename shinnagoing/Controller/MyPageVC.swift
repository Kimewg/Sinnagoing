import UIKit
import SnapKit
import CoreData

class MyPageVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()

    
    
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
        label.text = "최영락님,"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var boardConditions: UILabel = {
        let label = UILabel()
        label.text = "천마논과 안전운전 하세요!"
        label.textColor = UIColor(hex: "915B5B")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var boardConditions2: UILabel = {
        let label = UILabel()
        label.text = "킥보드 타기 좋은 날씨에요!"
        label.textColor = .clear
        //        label.textColor = UIColor(hex: "915B5B")
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        configure()
        updateImageBasedOnRentalStatus()
        debugKickboardData()
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
        
        [useImageView, userLabel, boardConditions, boardConditions2].forEach { usingView.addSubview($0) }
        
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
        
        boardConditions2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
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
    
    func debugKickboardData() {
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()

        do {
            let kickboards = try context.fetch(fetchRequest)
            print("📋 전체 킥보드 수: \(kickboards.count)")
            for board in kickboards {
                print("🧾 board.id: \(board.objectID), isRentaled: \(board.isRentaled)")
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
            print("📦 가져온 킥보드 수: \(rentedKickboards.count)")
            for board in rentedKickboards {
                print("🛴 킥보드 상태 isRentaled: \(board.isRentaled)")
            }

            let imageName = rentedKickboards.isEmpty ? "horse2" : "horse"
            DispatchQueue.main.async {
                self.useImageView.image = UIImage(named: imageName)
                print("✅ 이미지 적용됨: \(imageName)")
                
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
    
    //    func imageForUseBoard(_ isRental: Bool) -> UIImage? {
    //        return isRental
    //        ? UIImage(named: "horse")   // 대여 중
    //        : UIImage(named: "horse2")  // 대여 중 아님
    //    }
    //
    //    func checkRentalStatusFromCoreData() {
    //        do {
    //            let results = try context.fetch(fetchRequest)
    //            for kickboard in results {
    //                print("킥보드 상태: \(kickboard.isRentaled)")
    //            }
    //
    //            let usingBoardExists = results.contains { $0.isRentaled == true }
    //            print("대여중 킥보드 있음? → \(usingBoardExists)")
    //
    //            DispatchQueue.main.async {
    //                self.isRental = usingBoardExists
    //                self.useImageView.image = self.imageForUseBoard(self.isRental) // <- 강제 갱신
    //            }
    //        } catch {
    //            print("CoreData fetch 실패: \(error)")
    //            DispatchQueue.main.async {
    //                self.isRental = false
    //                self.useImageView.image = self.imageForUseBoard(self.isRental)
    //            }
    //        }
    //    }
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
