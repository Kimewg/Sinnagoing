import UIKit
import SnapKit

// 모달을 띄우는 함수
func presentModal(from viewController: UIViewController, battery: Int16) {
    let modalVC = UIViewController()
    modalVC.modalPresentationStyle = .pageSheet
    modalVC.view.backgroundColor = .white
    
    if let sheet = modalVC.sheetPresentationController {
        sheet.detents = [.custom { context in
            return 200 // 원하는 높이 설정
        }]
    }
    // 배터리 라벨
    let batteryLabel = UILabel()
    batteryLabel.text = "\(battery)%"
    batteryLabel.font = UIFont.systemFont(ofSize: 43, weight: .bold)
    batteryLabel.textColor = .black
    batteryLabel.textAlignment = .center
    // 배터리 이미지
    let batteryImageView = UIImageView(image: UIImage(named: "battery"))
    batteryImageView.contentMode = .scaleAspectFit
    // 분당 가격 라벨
    let priceLabel = UILabel()
    priceLabel.text = "1분당 3500만원"
    priceLabel.font = UIFont.systemFont(ofSize: 18)
    priceLabel.textColor = UIColor(red: 0.747, green: 0.747, blue: 0.747, alpha: 1)
    priceLabel.textAlignment = .center
    // 킥보드 이미지
    let imageView = UIImageView(image: UIImage(named: "image"))
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    // 쿠폰 버튼
    let couponButton = UIButton()
    couponButton.setTitle("찰보리빵 10% 쿠폰 지금 받아가세요!", for: .normal)
    couponButton.frame = CGRect(x: 0, y: 0, width: 372, height: 41)
    couponButton.setTitleColor(UIColor(red: 0.784, green: 0.624, blue: 0.263, alpha: 1), for: .normal)
    couponButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    couponButton.layer.cornerRadius = 10
    couponButton.layer.borderWidth = 1
    couponButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
    // 닫기 버튼
    let closeButton = UIButton()
    closeButton.setTitle("닫기", for: .normal)
    closeButton.backgroundColor = .white
    closeButton.setTitleColor(.black, for: .normal)
    closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    closeButton.layer.cornerRadius = 10
    closeButton.layer.borderWidth = 1
    closeButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
    closeButton.addTarget(viewController, action: #selector(viewController.closeButtonTapped), for: .touchUpInside)
    // 대여하기 버튼
    let rentButton = UIButton()
    rentButton.setTitle("대여하기", for: .normal)
    rentButton.backgroundColor = UIColor(red: 0.784, green: 0.624, blue: 0.263, alpha: 1)
    rentButton.setTitleColor(.black, for: .normal)
    rentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    rentButton.layer.cornerRadius = 10
    rentButton.layer.borderWidth = 1
    rentButton.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
    rentButton.addTarget(modalVC, action: #selector(modalVC.rentButtonTapped), for: .touchUpInside)
    [
        batteryLabel,
        batteryImageView,
        priceLabel,
        imageView,
        couponButton,
        closeButton,
        rentButton
    ].forEach { modalVC.view.addSubview($0) }
    
    // 오토레이아웃 설정
    // 배터리 라벨
    batteryLabel.snp.makeConstraints {
        $0.top.equalTo(modalVC.view.safeAreaLayoutGuide).offset(20)
        $0.leading.equalTo(modalVC.view.safeAreaLayoutGuide).offset(30)
    }
    // 배터리 이미지 라벨
    batteryImageView.snp.makeConstraints {
        $0.centerY.equalTo(batteryLabel)
        $0.leading.equalTo(batteryLabel.snp.trailing).offset(8)
        $0.width.height.equalTo(24)
    }
    // 분당 가격 라벨
    priceLabel.snp.makeConstraints {
        $0.top.equalTo(batteryLabel.snp.bottom).offset(5)
        $0.leading.equalTo(modalVC.view.safeAreaLayoutGuide).offset(30)
    }
    // 킥보드 이미지
    imageView.snp.makeConstraints {
        $0.top.equalTo(modalVC.view.safeAreaLayoutGuide).offset(20)
        $0.trailing.equalTo(modalVC.view.safeAreaLayoutGuide).offset(-20)
        $0.width.height.equalTo(80) // 킥보드 이미지 크기 설정
    }
    // 쿠폰 버튼
    couponButton.snp.makeConstraints {
        $0.top.equalTo(priceLabel.snp.bottom).offset(10)
        $0.centerX.equalTo(modalVC.view)
    }
    // 닫기 버튼
    closeButton.snp.makeConstraints {
        $0.top.equalTo(couponButton.snp.bottom).offset(20)
        $0.leading.equalTo(modalVC.view.safeAreaLayoutGuide).offset(20)
        $0.width.equalTo(modalVC.view.snp.width).multipliedBy(0.4)
        $0.height.equalTo(40)
    }
    // 대여하기 버튼
    rentButton.snp.makeConstraints {
        $0.top.equalTo(couponButton.snp.bottom).offset(20)
        $0.trailing.equalTo(modalVC.view.safeAreaLayoutGuide).offset(-20)
        $0.width.equalTo(closeButton)
        $0.height.equalTo(40)
    }
    
    viewController.present(modalVC, animated: true, completion: nil)
}

extension UIViewController {
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rentButtonTapped() {
        let alert = UIAlertController(title: "대여가 완료되었습니다.", message: nil, preferredStyle: .alert)
        
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("대여가 완료되었습니다.")
            // 모달을 닫고 returnButton을 보이게 함
            self.dismiss(animated: true, completion: {
                if let mapVC = self as? MapVC {
                    mapVC.returnButton.isHidden = false // MapVC에서 returnButton 보이게 함
                }
            })
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}

