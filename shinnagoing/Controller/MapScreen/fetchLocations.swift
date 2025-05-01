//import Foundation
//
//class fetchLocations {
//    var mapVC: MapVC?
//    // 주어진 query를 바탕으로 네이버 API를 호출하여 장소를 검색하는 함수
//    private func fetchLocations(query: String) {
//        // 쿼리 문자열을 URL에서 사용 가능한 형식으로 인코딩
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        
//        // 네이버 API의 요청 URL 생성
//        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=1&start=1&sort=random"
//        
//        // URL 객체로 변환
//        guard let url = URL(string: urlString) else { return }
//        
//        // URLRequest 객체 생성
//        var request = URLRequest(url: url)
//        let clientId = "ShRXCRqun5rU_NczZPRP"
//        let clientSecret = "DAZxZOtKQl"
//        // 클라이언트 ID와 시크릿을 HTTP 헤더에 추가
//        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
//        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
//        
//        // 네이버 API에 요청을 보내고 응답을 처리하는 비동기 작업
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            // self가 해제되었으면 종료
//            guard let self else { return }
//            
//            // 요청 오류가 있을 경우
//            if let error = error {
//                print("네이버 API 요청 실패: \(error.localizedDescription)")
//                return
//            }
//            
//            // 응답 데이터가 있을 경우, 응답 데이터를 문자열로 변환하여 출력
//            if let data = data {
//                let responseString = String(data: data, encoding: .utf8)
//                print("네이버 API 응답 데이터: \(responseString ?? "응답 데이터 없음")")
//            }
//            
//            // 응답 데이터가 없으면 종료
//            guard let data else { return }
//            
//            // 응답 데이터를 파싱하여 SearchResult 객체로 변환
//            do {
//                let result = try JSONDecoder().decode(SearchResult.self, from: data)
//                
//                // 검색 결과가 없으면 경고 메시지를 띄움
//                if result.items.isEmpty {
//                    DispatchQueue.main.async {
//                        self.presentAlert(title: "검색 결과 없음", message: "장소를 찾을 수 없습니다.")
//                    }
//                } else {
//                    // 검색 결과가 있으면 첫 번째(title) 항목을 처리
//                    let roadAddress = result.items.first?.roadAddress ?? ""
//                    let address = result.items.first?.address ?? ""
//                    if roadAddress.count > 0 {
//                        self.geocodeAddress(roadAddress)
//                    } else {
//                        self.geocodeAddress(address)
//                    }
//                }
//            } catch {
//                // 파싱 오류가 발생하면 오류 메시지를 출력하고 알림을 띄움
//                print("파싱 에러: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.presentAlert(title: "파싱 오류", message: "응답 데이터가 잘못되었습니다.")
//                }
//            }
//        }.resume()  // 비동기 요청 시작
//    }
//}
