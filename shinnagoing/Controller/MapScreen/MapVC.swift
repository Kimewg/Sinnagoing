import UIKit
import NMapsMap
import SnapKit
import CoreData

class MapVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var markers: [NMFMarker] = []
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "어디로 가시나요?"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = UIColor(red: 0.632, green: 0.604, blue: 0.604, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor(red: 0.523, green: 0.523, blue: 0.523, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "SINNAGOING"
        label.textColor = UIColor(red: 0.784, green: 0.624, blue: 0.263, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupInitialCamera()
        
        // 더미 데이터 저장
        let kickboard1 = KickboardEntity(context: context)
        kickboard1.kickboardID = "kickboard_001"
        kickboard1.latitude = 35.836
        kickboard1.longitude = 129.219
        kickboard1.battery = 100
        
        let kickboard2 = KickboardEntity(context: context)
        kickboard2.kickboardID = "kickboard_002"
        kickboard2.latitude = 35.836
        kickboard2.longitude = 129.216
        kickboard2.battery = 70
        
        do {
            try context.save()
            fetchDataMarkers()
        } catch {
            print("저장 실패")
        }
    }
    
    private func setupInitialCamera() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.836, lng: 129.219)) // 경주
        mapView.moveCamera(cameraUpdate)
    }
    
    private func fetchDataMarkers() {
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        do {
            let kickboards = try context.fetch(fetchRequest)
            for kickboard in kickboards {
                addMarker(kickboard: kickboard)
            }
        } catch {
            print("Error fetching locations: \(error)")
        }
    }

    private func addMarker(kickboard: KickboardEntity) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: kickboard.latitude, lng: kickboard.longitude)
        marker.mapView = mapView
        markers.append(marker)
        
        // 마커에 킥보드 정보를 저장
        marker.userInfo = [
            "kickboardID": kickboard.kickboardID ?? "",
            "battery": kickboard.battery
        ]
        
        // 마커를 터치했을 때 모달 띄우기
        marker.touchHandler = { [weak self] (overlay) -> Bool in
            guard let self = self else { return true }
            if let marker = overlay as? NMFMarker,
               let userInfo = marker.userInfo as? [String: Any],
               let battery = userInfo["battery"] as? Int16 {
                presentModal(from: self, battery: battery)
            }
            return true
        }
    }

    private func configureUI() {
        view.backgroundColor = .white
        
        [logoLabel, mapView, searchTextField].forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
}
