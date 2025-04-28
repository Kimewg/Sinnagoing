import SnapKit
import UIKit
class JoinVC: UIViewController {
    var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력하세요."
        textField.text = ""
        textField.textColor = UIColor(hex: "C89F43")
        textField.backgroundColor = UIColor(hex: "FFFFFF")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var passWordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.text = ""
        textField.isSecureTextEntry = true
        textField.textContentType = .username
        textField.textColor = UIColor(hex: "C89F43")
        textField.backgroundColor = UIColor(hex: "FFFFFF")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var secondPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 한번 더 입력하세요."
        textField.text = ""
        textField.isSecureTextEntry = true
        textField.textContentType = .username
        textField.textColor = UIColor(hex: "C89F43")
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        return textField
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "joinLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(hex: "C89F43")
        return button
    }()
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "CFC8C8")
        return separator
    }()
    let kakaoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "kakao")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    let naver: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "naver")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    let sparta: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sparta")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationItem()
        // 버튼 액션 추가
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    func navigationItem() {
        self.title = "회원 가입"
        self.navigationController?.navigationBar.tintColor = .black
    }
    func configure() {
        view.backgroundColor = .white
        [ idTextField,
          passWordTextField,
          secondPasswordTextField,
          imageView,
          joinButton,
          separator,
          naver,
          kakaoImage,
          sparta].forEach { view.addSubview($0) }
        idTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalToSuperview().offset(164)
            make.height.equalTo(55)
        }
        passWordTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(idTextField.snp.bottom).offset(12)
            make.height.equalTo(55)
        }
        secondPasswordTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(passWordTextField.snp.bottom).offset(12)
            make.height.equalTo(55)
        }
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(31)
            make.trailing.equalToSuperview().inset(198)
            make.bottom.equalTo(idTextField.snp.top).offset(-9)
            make.height.equalTo(53)
            make.width.equalTo(173)
        }
        joinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondPasswordTextField.snp.bottom).offset(32)
            make.width.equalTo(254)
            make.height.equalTo(55)
        }
        separator.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(31)
            make.top.equalTo(joinButton.snp.bottom).offset(34)
            make.height.equalTo(1)
        }
        naver.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(separator.snp.bottom).offset(72)
            make.width.equalTo(55)
        }
        kakaoImage.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(naver.snp.bottom).offset(24)
            make.width.equalTo(55)
        }
        sparta.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalTo(kakaoImage.snp.bottom).offset(24)
            make.width.equalTo(55)
        }
    }
    @objc func joinButtonTapped() {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passWordTextField.text, !password.isEmpty,
              let confirmPassword = secondPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "오류", message: "아이디 또는 비밀번호가 비어있습니다.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "비밀번호 불일치", message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
        // 기존 회원 리스트 가져오기
        var users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] ?? []

        // 새 회원 추가
        let newUser = ["id": id, "password": password]
        users.append(newUser)

        // 저장
        UserDefaults.standard.set(users, forKey: "users")

        print("회원가입 성공: \(id)")
        navigationController?.popViewController(animated: true)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
