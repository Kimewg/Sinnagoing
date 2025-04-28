import UIKit
import SnapKit

class LoginVC: UIViewController {
    var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력하세요."
        textField.text = ""
        textField.textColor = UIColor(hex: "C89F43")
        textField.backgroundColor = UIColor(hex: "F6F6F6")
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
        textField.backgroundColor = UIColor(hex: "F6F6F6")
        textField.borderStyle = .roundedRect
        return textField
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "C89F43")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        navigationItemSetting()

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }

    func navigationItemSetting() {
        self.title = "로그인"
        self.navigationController?.navigationBar.tintColor = .black
    }

    func configure() {
        [idTextField, passWordTextField, imageView, loginButton, joinButton].forEach { view.addSubview($0) }

        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(393)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }

        passWordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }

        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(idTextField.snp.top).offset(-62)
            make.centerX.equalToSuperview()
            make.height.equalTo(94)
            make.width.equalTo(143)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(42)
        }

        joinButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(42)
        }
    }

    @objc func loginButtonTapped() {
        guard let id = idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !id.isEmpty,
              let password = passWordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showAlert(title: "오류", message: "아이디와 비밀번호를 모두 입력해주세요.")
            return
        }
        
        // 저장된 회원 리스트 가져오기
        let users = UserDefaults.standard.array(forKey: "users") as? [[String: String]] ?? []
        
        // 입력한 정보와 일치하는 회원이 있는지 확인
        if users.contains(where: { $0["id"] == id && $0["password"] == password }) {
            print("로그인 성공")
            moveToMapVC()
        } else {
            showAlert(title: "로그인 실패", message: "아이디 또는 비밀번호가 일치하지 않습니다.")
        }
    }

    func moveToMapVC() {
        let mapVC = MapVC()
        navigationController?.pushViewController(mapVC, animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    @objc func joinButtonTapped() {
        let joinVC = JoinVC()
        navigationController?.pushViewController(joinVC, animated: true)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
