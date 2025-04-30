import SnapKit
import UIKit

class JoinVC: UIViewController {
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 입력"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.text = ""
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F5F5F5")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var idLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디 입력"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.text = ""
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F5F5F5")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var passWordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 입력"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    var passWordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.text = ""
        // 비밀번호를 입력할때 비밀번호가 안보이게 입력
        textField.isSecureTextEntry = true
        textField.textContentType = .username
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F5F5F5")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var secondPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    var secondPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.text = ""
        textField.isSecureTextEntry = true
        textField.textContentType = .username
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F5F5F5")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(hex: "915B5B")
        return button
    }()
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "CFC8C8")
        return separator
    }()
    var socialLabel: UILabel = {
        let label = UILabel()
        label.text = "간편로그인"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(hex: "888888")
        return label
    }()
    var kakaoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "kakao")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    var spartaImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sparta")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    var naverImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "naver")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationItem()
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    func navigationItem() {
        self.title = "회원 가입"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func configure() {
        view.backgroundColor = .white
        [ userNameLabel,
          userNameTextField,
          idLabel,
          idTextField,
          passWordLabel,
          passWordTextField,
          secondPasswordLabel,
          secondPasswordTextField,
          joinButton,
          separator,
          socialLabel,
          kakaoImage,
          spartaImage,
          naverImage].forEach { view.addSubview($0) }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(139)
            make.width.equalTo(159)
        }
        userNameTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(userNameLabel.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalTo(userNameTextField.snp.bottom).offset(16)
            make.width.equalTo(175)
        }
        idTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(idLabel.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        passWordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalTo(idTextField.snp.bottom).offset(16)
            make.width.equalTo(192)
        }
        passWordTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(passWordLabel.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        secondPasswordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalTo(passWordTextField.snp.bottom).offset(16)
            make.width.equalTo(251)
        }
        secondPasswordTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(secondPasswordLabel.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        
        joinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondPasswordTextField.snp.bottom).offset(41)
            make.width.equalTo(254)
            make.height.equalTo(55)
        }
        separator.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(31)
            make.top.equalTo(joinButton.snp.bottom).offset(51)
            make.height.equalTo(1)
        }
        socialLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(25)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        kakaoImage.snp.makeConstraints { make in
            make.leading.equalTo(90)
            make.top.equalTo(separator.snp.bottom).offset(64)
            make.size.equalTo(48)
        }
        spartaImage.snp.makeConstraints { make in
            make.leading.equalTo(kakaoImage.snp.trailing).offset(33)
            make.top.equalTo(separator.snp.bottom).offset(71)
            make.width.equalTo(60)
            make.height.equalTo(32)
        }
        naverImage.snp.makeConstraints { make in
            make.leading.equalTo(spartaImage.snp.trailing).offset(33)
            make.top.equalTo(separator.snp.bottom).offset(64)
            make.size.equalTo(48)
        }
    }
    @objc func joinButtonTapped() {
            guard let name = userNameTextField.text, !name.isEmpty,
                  let id = idTextField.text, !id.isEmpty,
                  let password = passWordTextField.text, !password.isEmpty,
                  let confirmPassword = secondPasswordTextField.text, !confirmPassword.isEmpty else {
                showAlert(title: "오류", message: "이름, 아이디 또는 비밀번호가 비어있습니다.")
                return
            }
            
            guard password == confirmPassword else {
                showAlert(title: "비밀번호 불일치", message: "비밀번호가 일치하지 않습니다.")
                return
            }
            
            // 기존 회원 리스트 가져오기
            var users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] ?? []

            // 새 회원 추가
        let newUser = ["name": name, "id": id, "password": password]
            users.append(newUser)
        

            // 저장
            UserDefaults.standard.set(users, forKey: "users")

            print("회원가입 성공: \(name) ( \(id))")
            navigationController?.popViewController(animated: true)
        }
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
