import UIKit
import CoreData
import SnapKit
import CoreData

class ModalVC: UIViewController {
    let context = CoreDataManager.shared.context
    var battery: Int16 = 0
    var mapVC: MapVC?
    var kickboardID: String?
    
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
        
        guard let mapVC = mapVC else { return }
        guard let selectedID = self.kickboardID else { return }
        //싱글톤 사용하지 않았을 경우에는 다음과 같이 호출.
        //let context = (UIApplication.shared.delegate as! Appdelegate).persistentContainer.viewContext
        
        // context 준비
        let context = CoreDataManager.shared.context
        // 어떤 엔티티를 가져올지 요청
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        
        // 조건 설정 (위에서 선언한 선택한 킥보드아이디와 같은 정보를 코어데이터에서 가져오기)
        fetchRequest.predicate = NSPredicate(format: "kickboardID == %@", selectedID)
        do {
            if let kickboard = try context.fetch(fetchRequest).first {
                kickboard.isRentaled = true
                
                let rental = RentalHistoryEntity(context: context)
                rental.kickboardID = selectedID
                rental.userID = "userID"
                rental.rentalDate = Date()
                rental.returnDate = nil
                
                try context.save()
                print("대여 완료")
                
                let alert = UIAlertController(title: "대여 완료", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.dismiss(animated: true) {
                        mapVC.returnButton.isHidden = false
                        mapVC.reloadMarkers()
                    }
                })
                self.present(alert, animated: true)
                
            } else {
                print("해당하는 킥보드를 찾을 수 없음")
            }
        } catch {
            print("대여 처리 중 오류: \(error)")
        }
    }
}

