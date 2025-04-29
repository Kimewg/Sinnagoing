import UIKit
import SnapKit

class ModalVC: UIViewController {
    var battery: Int16 = 0
    var mapVC: MapVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        modalPresentationStyle = .pageSheet
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom { _ in 200 }]
        }
        
        // --- UI 컴포넌트 만들기 ---
        let batteryLabel = UILabel()
        batteryLabel.text = "\(battery)%"
        batteryLabel.font = UIFont.systemFont(ofSize: 43, weight: .bold)
        batteryLabel.textColor = .black
        batteryLabel.textAlignment = .center
        
        let batteryImageView = UIImageView(image: UIImage(named: "battery"))
        batteryImageView.contentMode = .scaleAspectFit
        
        let priceLabel = UILabel()
        priceLabel.text = "1분당 3500만원"
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textColor = UIColor(red: 0.747, green: 0.747, blue: 0.747, alpha: 1)
        priceLabel.textAlignment = .center
        
        let imageView = UIImageView(image: UIImage(named: "image"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        let couponButton = UIButton()
        couponButton.setTitle("찰보리빵 10% 쿠폰 지금 받아가세요!", for: .normal)
        couponButton.setTitleColor(UIColor(red: 0.784, green: 0.624, blue: 0.263, alpha: 1), for: .normal)
        couponButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        couponButton.layer.cornerRadius = 10
        couponButton.layer.borderWidth = 1
        couponButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
        
        let closeButton = UIButton()
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        closeButton.layer.cornerRadius = 10
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let rentButton = UIButton()
        rentButton.setTitle("대여하기", for: .normal)
        rentButton.backgroundColor = UIColor(red: 0.784, green: 0.624, blue: 0.263, alpha: 1)
        rentButton.setTitleColor(.black, for: .normal)
        rentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rentButton.layer.cornerRadius = 10
        rentButton.layer.borderWidth = 1
        rentButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
        rentButton.addTarget(self, action: #selector(rentButtonTapped), for: .touchUpInside)
        
        [
            batteryLabel,
            batteryImageView,
            priceLabel,
            imageView,
            couponButton,
            closeButton,
            rentButton
        ].forEach { view.addSubview($0) }
        
        // --- 오토레이아웃 ---
        batteryLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        batteryImageView.snp.makeConstraints {
            $0.centerY.equalTo(batteryLabel)
            $0.leading.equalTo(batteryLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(24)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(batteryLabel.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.height.equalTo(80)
        }
        
        couponButton.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(couponButton.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(view.snp.width).multipliedBy(0.4)
            $0.height.equalTo(40)
        }
        
        rentButton.snp.makeConstraints {
            $0.top.equalTo(couponButton.snp.bottom).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(closeButton)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func rentButtonTapped() {
        let alert = UIAlertController(title: "대여가 완료되었습니다.", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("대여가 완료되었습니다.")
            self.dismiss(animated: true) {
                self.mapVC?.returnButton.isHidden = false
            }
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}

