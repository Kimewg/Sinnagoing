import UIKit
import SnapKit
import CoreData

class LoginVC: UIViewController {
    
    let splashView = SplashView()
    
    var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력하세요."
        textField.text = ""
        textField.textColor = UIColor(hex: "915B5B")
        textField.backgroundColor = UIColor(hex: "F6F6F6")
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var passWordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.text = ""
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.textColor = UIColor(hex: "915B5B")
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#915B5B")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor(hex: "#915B5B"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        splashView.frame = view.bounds
        view.addSubview(splashView)
        
        // 여기서 맨 앞의 뷰로 확실히 지정해줌
        view.bringSubviewToFront(splashView)
        
        // 현재에서 2초 후에 dismiss되게 세팅
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismissSplashView()
        }
    }
    
    func configure() {
        [idTextField,
         passWordTextField,
         imageView,
         loginButton,
         joinButton].forEach { view.addSubview($0) }
        
        idTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(40)
            make.top.equalToSuperview().offset(393)
            make.height.equalTo(44)
        }
        
        passWordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(idTextField.snp.bottom).offset(23)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(idTextField.snp.top).offset(-52)
            make.centerX.equalToSuperview()
            make.height.equalTo(155)
            make.width.equalTo(142)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(42)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(42)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passWordTextField.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(42)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(40)
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
        if let user = users.first(where: { $0["id"] == id && $0["password"] == password }) {
            // 로그인 성공 시 currentUserID와 currentUserName 저장
            UserDefaults.standard.set(id, forKey: "currentUserID")
            if let name = user["name"] {
                UserDefaults.standard.set(name, forKey: "currentUserName") // 사용자 이름 저장
            }
            print("로그인 성공")
            moveToTabBar()
        } else {
            showAlert(title: "로그인 실패", message: "아이디 또는 비밀번호가 일치하지 않습니다.")
        }
    }
    func moveToTabBar() {
        let tabBarVC = TabBarVC()
        // 앱의 윈도우 루트를 TabBarVC로 교체
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    @objc func buttonTapped() {
        print("클릭됨")
        let vc = JoinVC()
        self.navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(vc, animated: true)
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
extension LoginVC {
    func dismissSplashView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.splashView.alpha = 0
        }) { _ in
            self.splashView.removeFromSuperview()
        }
    }
}
