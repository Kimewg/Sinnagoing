import UIKit
import NMapsMap
import SnapKit
import CoreData
import CoreLocation

class MapVC: UIViewController {
    
    // MARK: - Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var markers: [NMFMarker] = []
    private let clientId = "ShRXCRqun5rU_NczZPRP"
    private let clientSecret = "DAZxZOtKQl"
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "어디로 가신라요?"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.textColor = UIColor(hex: "#915B5B")
        textField.layer.borderColor = UIColor(red: 0.523, green: 0.523, blue: 0.523, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(focusSearchField), for: .touchUpInside)
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
    
    private let logoLabel: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "stringLogo")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("반납하기", for: .normal)
        button.backgroundColor = UIColor(red: 0.9, green: 0.4, blue: 0.4, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "locationIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor(hex: "915B5B").cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupInitialCamera()
        DummyDataManager.shared.insertKickboardDummyData()
        fetchDataMarkers()
        searchTextField.delegate = self
        
        // 키보드가 자동으로 올라오도록 설정
        DispatchQueue.main.async {
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        view.backgroundColor = .white
        [logoLabel, mapView, searchTextField, returnButton, myLocationButton].forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.height.equalTo(41)
            $0.width.equalTo(164)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(63)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        returnButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        myLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Map & Marker Logic
    
    // 초기 카메라 위치를 설정하는 함수
    private func setupInitialCamera() {
        // 경주(35.836, 129.219) 위치로 카메라를 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.836, lng: 129.219))
        // 지도에 카메라 이동 적용
        mapView.moveCamera(cameraUpdate)
    }
    
    // 데이터베이스에서 킥보드 정보를 가져와서 마커를 추가하는 함수
    private func fetchDataMarkers() {
        // KickboardEntity에 대한 FetchRequest 생성
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        // 조건걸어주기(isRentaled이 false인 데이터만)
        // Core Data는 Bool 타입 필터링할 때 NSNumber로 변환해야한다(Swift에서는 true/false지만, 내부적으로 NSNumber를 쓰기때문)
        fetchRequest.predicate = NSPredicate(format: "isRentaled == %@", NSNumber(value: false))
        
        do {
            // 데이터베이스에서 킥보드 데이터 가져오기
            let kickboards = try context.fetch(fetchRequest)
            // 각 킥보드에 대해 마커를 추가
            kickboards.forEach {
                if !$0.isRentaled {
                    addMarker(kickboard: $0)
                }
            }
        } catch {
            // 데이터 가져오기 실패 시 에러 출력
            print("Error fetching locations: \(error)")
        }
    }
    
    // 킥보드 데이터를 기반으로 마커를 지도에 추가하는 함수
    private func addMarker(kickboard: KickboardEntity) {
        // NMFMarker 객체 생성
        let marker = NMFMarker()
        // 마커의 위치를 킥보드의 위도, 경도에 맞게 설정
        marker.position = NMGLatLng(lat: kickboard.latitude, lng: kickboard.longitude)
        marker.mapView = mapView  // 마커를 지도에 추가
        
        // 마커 배열에 추가 (마커 관리용)
        markers.append(marker)
        
        // 마커에 킥보드 정보를 userInfo에 저장
        marker.userInfo = [
            "kickboardID": kickboard.kickboardID ?? "",  // 킥보드 ID
            "battery": kickboard.battery  // 배터리 상태
        ]
        
        // 마커를 터치했을 때의 핸들러 설정
        marker.touchHandler = { [weak self] overlay -> Bool in
            // self가 해제되었으면 종료
            guard let self else { return true }
            
            // 터치된 overlay가 NMFMarker인지 확인하고, userInfo에서 배터리 상태를 가져옴
            guard let marker = overlay as? NMFMarker,
                  let userInfo = marker.userInfo as? [String: Any],
                  let battery = userInfo["battery"] as? Int16,
                  let kickboardID = userInfo["kickboardID"] as? String else { return true }
            
            // 배터리 정보를 보여줄 ModalVC 생성
            let modalVC = ModalVC()
            modalVC.battery = battery  // 배터리 정보를 ModalVC에 전달
            modalVC.mapVC = self  // 현재 ViewController를 ModalVC에 전달
            modalVC.kickboardID = kickboardID
            // ModalVC를 화면에 표시
            self.present(modalVC, animated: true)
            return true
        }
    }
    // 마커 리로드 함수
    func reloadMarkers() {
        // 현재 마커들 지도에서 지우기
        for marker in markers {
            marker.mapView = nil
        }
        markers.removeAll()
        
        // 새로 fetch해서 마커 추가
        fetchDataMarkers()
    }
    
    
    // MARK: - Actions
    
    @objc private func returnButtonTapped() {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isRentaled == %@", NSNumber(value: true))
        
        do {
            if let kickboard = try context.fetch(fetchRequest).first {
                
                
                kickboard.isRentaled = false
                kickboard.battery -= 8
                //임시용
                kickboard.latitude -= 0.001
                kickboard.longitude += 0.001
                
                try context.save()
                
                let alert = UIAlertController(title: "반납 완료", message: "킥보드를 반납했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.returnButton.isHidden = true
                    
                })
                present(alert, animated: true)
                
                reloadMarkers()
            }
        } catch {
            print("반납 처리 중 오류")
        }
    }
    @objc func focusSearchField() {
        searchTextField.becomeFirstResponder()
    }
    @objc func myLocationButtonTapped() {
        
    }
    // MARK: - Naver API
    
    // 주어진 query를 바탕으로 네이버 API를 호출하여 장소를 검색하는 함수
    private func fetchLocations(query: String) {
        // 쿼리 문자열을 URL에서 사용 가능한 형식으로 인코딩
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // 네이버 API의 요청 URL 생성
        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=1&start=1&sort=random"
        
        // URL 객체로 변환
        guard let url = URL(string: urlString) else { return }
        
        // URLRequest 객체 생성
        var request = URLRequest(url: url)
        // 클라이언트 ID와 시크릿을 HTTP 헤더에 추가
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        // 네이버 API에 요청을 보내고 응답을 처리하는 비동기 작업
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // self가 해제되었으면 종료
            guard let self else { return }
            
            // 요청 오류가 있을 경우
            if let error = error {
                print("네이버 API 요청 실패: \(error.localizedDescription)")
                return
            }
            
            // 응답 데이터가 있을 경우, 응답 데이터를 문자열로 변환하여 출력
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("네이버 API 응답 데이터: \(responseString ?? "응답 데이터 없음")")
            }
            
            // 응답 데이터가 없으면 종료
            guard let data else { return }
            
            // 응답 데이터를 파싱하여 SearchResult 객체로 변환
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                
                // 검색 결과가 없으면 경고 메시지를 띄움
                if result.items.isEmpty {
                    DispatchQueue.main.async {
                        self.presentAlert(title: "검색 결과 없음", message: "장소를 찾을 수 없습니다.")
                    }
                } else {
                    // 검색 결과가 있으면 첫 번째(title) 항목을 처리
                    let roadAddress = result.items.first?.roadAddress ?? ""
                    let address = result.items.first?.address ?? ""
                    if roadAddress.count > 0 {
                        self.geocodeAddress(roadAddress)
                    } else {
                        self.geocodeAddress(address)
                    }
                }
            } catch {
                // 파싱 오류가 발생하면 오류 메시지를 출력하고 알림을 띄움
                print("파싱 에러: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.presentAlert(title: "파싱 오류", message: "응답 데이터가 잘못되었습니다.")
                }
            }
        }.resume()  // 비동기 요청 시작
    }
    // MARK: search map Camera
    // 주소를 위도와 경도로 변환하여 지도 위치를 이동시키는 함수
    private func geocodeAddress(_ address: String) {
        let geocoder = CLGeocoder()
        // 주소를 위도, 경도로 변환하는 작업
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            // self가 해제되었으면 종료
            guard let self else { return }
            
            // 주소 변환 중 오류가 발생했을 경우
            if let error = error {
                print("주소 변환 오류: \(error.localizedDescription)")
                self.presentAlert(title: "주소 오류", message: "주소가 없습니다")
                return
            }
            
            // 변환된 위치가 없으면 경고 메시지를 띄움
            guard let location = placemarks?.first?.location else {
                self.presentAlert(title: "주소 오류", message: "주소가 없습니다")
                return
            }
            
            // 위치 정보를 통해 카메라 위치 업데이트
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            
            // 메인 스레드에서 지도 위치 이동
            DispatchQueue.main.async {
                self.mapView.moveCamera(cameraUpdate)
            }
        }
    }
    
    // 사용자에게 알림을 표시하는 함수
    private func presentAlert(title: String, message: String) {
        // 알림 컨트롤러 생성
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // 확인 버튼 추가
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        // 메인 스레드에서 알림 표시
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension MapVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 텍스트 필드에 입력된 텍스트가 비어 있지 않으면
        guard let query = textField.text, !query.isEmpty else { return true }
        // 입력된 텍스트를 기반으로 장소 검색 함수 호출
        fetchLocations(query: query)
        textField.resignFirstResponder()
        return true
    }
}

