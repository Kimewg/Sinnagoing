import UIKit
import SnapKit
import NMapsMap

class AddBoardVC: UIViewController {
    
    let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.borderWidth = 1
        return mapView
    }()
    
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
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F6F6F6")
        textField.borderStyle = .roundedRect
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.tintColor = UIColor(hex: "#915B5B")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
        containerView.addSubview(iconImageView)
        iconImageView.center = containerView.center
        
        textField.rightView = containerView
        textField.rightViewMode = .always
        return textField
    }()
    
    let addButtton : UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor(hex: "E7E2CC"), for: .normal)
        button.backgroundColor = UIColor(hex: "915B5B")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
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
         separator,
         addLabel,
         mapView,
         addButtton].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(142)
        }
        
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
        
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(label2.snp.bottom).offset(16)
            make.height.equalTo(332)
        }
        
        address.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom).offset(33)
            make.width.equalTo(348)
            make.height.equalTo(44)
        }
        
        addButtton.snp.makeConstraints { make in
            make.top.equalTo(address.snp.bottom).offset(25)
            make.trailing.leading.equalToSuperview().inset(26)
            make.height.equalTo(46)
        }
        
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
