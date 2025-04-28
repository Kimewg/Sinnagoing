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
        
        //더미데이터 기본값 첫 앱 실행시 받아오도록.(기본더미데이터 중복 되지 않도록 설정해 둠)
        DummyDataManager.shared.insertKickboardDummyData()
        
        fetchDataMarkers()

    }
    
    private func setupInitialCamera() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.836, lng: 129.219)) // 경주
        mapView.moveCamera(cameraUpdate)
    }
    
    private func fetchDataMarkers() {
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        do {
            let kickboards = try context.fetch(fetchRequest)
            
            // Core Data에서 가져온 데이터를 기반으로 마커를 지도에 추가
            for kickboard in kickboards {
                let latitude = kickboard.latitude
                let longitude = kickboard.longitude
                addMarker(latitude: latitude, longitude: longitude)
            }
        } catch {
            print("Error fetching locations: \(error)")
        }
        
    }
    
    private func addMarker(latitude: Double, longitude: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.mapView = mapView
        markers.append(marker)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        // UI 요소들을 뷰에 추가
        [
            logoLabel,
            mapView,
            searchTextField
        ].forEach { view.addSubview($0) }
        
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
