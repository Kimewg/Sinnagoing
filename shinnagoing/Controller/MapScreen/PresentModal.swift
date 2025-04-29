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
        batteryLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        batteryLabel.textColor = .black
        batteryLabel.textAlignment = .center
        
        let batteryImageView = UIImageView(image: UIImage(named: "battery"))
        batteryImageView.contentMode = .scaleAspectFit

        let kickBoardImageView = UIImageView(image: UIImage(named: "kickBoard"))
        kickBoardImageView.contentMode = .scaleAspectFit
        
        let priceLabel = UILabel()
        priceLabel.text = "1분당 3500만원"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        priceLabel.textColor = UIColor(hex: "BEBEBE")
        priceLabel.textAlignment = .center
        
        let coupon = UIImageView()
        coupon.image = UIImage(named: "coupon")
        coupon.contentMode = .scaleAspectFit
        coupon.clipsToBounds = true
        
        let closeButton = UIButton()
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(UIColor(hex: "#915B5B"), for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.layer.cornerRadius = 10
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor(hex: "915B5B").cgColor
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let rentButton = UIButton()
        rentButton.setTitle("대여하기", for: .normal)
        rentButton.backgroundColor = UIColor(hex: "915B5B")
        rentButton.setTitleColor(UIColor(hex: "E7E2CC"), for: .normal)
        rentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        rentButton.layer.cornerRadius = 10
        rentButton.layer.borderWidth = 1
        rentButton.layer.borderColor = UIColor(hex: "915B5B").cgColor
        rentButton.addTarget(self, action: #selector(rentButtonTapped), for: .touchUpInside)
        
        [
            batteryLabel,
            batteryImageView,
            kickBoardImageView,
            priceLabel,
            coupon,
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
            $0.height.equalTo(29)
            $0.width.equalTo(55)
        }
        
        kickBoardImageView.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(52)
            make.leading.equalTo(batteryImageView.snp.trailing).offset(145)
            make.top.equalToSuperview().offset(17)
        }
    
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(batteryLabel.snp.bottom).offset(1)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        
        coupon.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(priceLabel.snp.bottom).offset(6)
            make.height.equalTo(41)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(coupon.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(45)
            make.width.equalTo(132)
            make.height.equalTo(43)
        }
        
        rentButton.snp.makeConstraints { make in
            make.top.equalTo(coupon.snp.bottom).offset(9)
            make.leading.equalTo(closeButton.snp.trailing).offset(48)
            make.width.equalTo(132)
            make.height.equalTo(43)
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

