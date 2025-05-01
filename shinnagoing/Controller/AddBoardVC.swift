import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class AddBoardVC: UIViewController, UITextFieldDelegate {
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    var addressTextField: UITextField = {
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
    
    lazy var addButtton : UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor(hex: "E7E2CC"), for: .normal)
        button.backgroundColor = UIColor(hex: "915B5B")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(registerKickboard), for: .touchDown)
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
        setupInitialCamera()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        addressTextField.delegate = self
    }
    private func setupInitialCamera() {
        // 경주(35.836, 129.219) 위치로 카메라를 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.836, lng: 129.219))
        // 지도에 카메라 이동 적용
        mapView.moveCamera(cameraUpdate)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let address = textField.text, !address.isEmpty else { return true }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let location = placemarks?.first?.location else { return }
            
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let update = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            self?.mapView.moveCamera(update)
        }
        
        return true
    }
    
    func configure() {
        [label,
         label2,
         addBoardImage,
         addressTextField,
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
        
        addressTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom).offset(33)
            make.width.equalTo(348)
            make.height.equalTo(44)
        }
        
        addButtton.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(25)
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
    
    @objc func registerKickboard() {
        if RentalManager.shared.checkUserIsRenting() {
            let alert = UIAlertController(title: "다메다메", message: "대여 중엔 안댐", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in })
            self.present(alert, animated: true)
            
        } else {
            guard let address = addressTextField.text, !address.isEmpty else {
                print("주소가 비어 있습니다.")
                return
            }
            
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
                if let error = error {
                    return
                }
                
                guard let location = placemarks?.first?.location else {
                    return
                }
                
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                UserDefaults.standard.set([latitude, longitude], forKey: "RegisteredKickboard")
                
                print("등록된 좌표: \(latitude), \(longitude)")
                
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: latitude, lng: longitude)
                marker.captionText = "킥보드 위치"
                marker.mapView = self?.mapView
                guard let self = self else { return }
                
                let newKickboard = KickboardEntity(context: self.context)
                newKickboard.kickboardID = UUID().uuidString
                newKickboard.latitude = latitude
                newKickboard.longitude = longitude
                newKickboard.isRentaled = false
                newKickboard.battery = 100
                
                do {
                    try context.save()
                    
                    if let tabBarVC = self.tabBarController,
                       let navVC = tabBarVC.viewControllers?[0] as? UINavigationController,
                       let mapVC = navVC.viewControllers.first as? MapVC {
                        mapVC.reloadMarkers()
                    }
                } catch {
                    print("저장 실패: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 0  // 0 = 지도 탭 인덱스
                }
            }
        }
    }
}

