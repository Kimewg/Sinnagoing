import UIKit
import SnapKit

class AddBoardVC: UIViewController {
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "어떤 위치에 킥보드를 저장하시겠나요?"
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    var label2: UILabel = {
        let label = UILabel()
        label.text = "주소를 입력하여\n이 위치에 킥보드를 저장하세요!"
        label.numberOfLines = 0 // 무제한 줄바꿈 가능!
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor(hex: "#9E9E9E")
        return label
    }()
    
    var addLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드 위치 저장하기"
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    var addBoardImage: UIImageView = {
        let add = UIImageView()
        add.image = UIImage(named: "addBoard")
        add.contentMode = .scaleAspectFit
        add.clipsToBounds = true
        return add
    }()
    
    var address: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주소를 입력하세요"
        textField.text = ""
        textField.textColor = UIColor(hex: "C89F43")
        textField.backgroundColor = UIColor(hex: "F6F6F6")
        textField.borderStyle = .roundedRect
        return textField
    }()
    
//    var longitude: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "경도를 입력하세요"
//        textField.text = ""
//        textField.textColor = UIColor(hex: "C89F43")
//        textField.backgroundColor = UIColor(hex: "F6F6F6")
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "CFC8C8")
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationController?.navigationBar.isHidden = true
    }
    
    func configure() {
        [label,
         label2,
         addBoardImage,
         address,
//         longitude,
         separator,
         addLabel].forEach { view.addSubview($0) }
    
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(156)
        }
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
        addBoardImage.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(90)
        }
        address.snp.makeConstraints { make in
            make.leading.equalTo(addBoardImage.snp.trailing).offset(15)
            make.top.equalTo(label2.snp.bottom).offset(50)
            make.height.equalTo(44)
            make.width.equalTo(227)
        }
//        longitude.snp.makeConstraints { make in
//            make.leading.equalTo(addBoardImage.snp.trailing).offset(15)
//            make.top.equalTo(latitude.snp.bottom).offset(14)
//            make.height.equalTo(44)
//            make.width.equalTo(227)
//        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(1)
            make.top.equalToSuperview().offset(98)
            make.height.equalTo(1)
        }
        addLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(63)
            make.centerX.equalToSuperview()
        }
    }
}
