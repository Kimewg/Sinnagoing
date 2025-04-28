import UIKit
import NMapsMap
import SnapKit

class MapVC: UIViewController {
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupInitialCamera()
    }

    private func setupInitialCamera() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.836, lng: 129.219))
        mapView.moveCamera(cameraUpdate)
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

