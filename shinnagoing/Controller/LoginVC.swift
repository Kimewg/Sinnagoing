import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    let splashView = SplashView()
    
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
        textField.textContentType = .password
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
        button.backgroundColor = UIColor(hex: "#915B5B")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
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
    @objc func buttonTapped() {
        print("Tap")
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
