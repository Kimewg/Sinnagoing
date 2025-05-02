
---

## 🧭 신나고잉 주요 기능 상세 설명

---

### 1. 🔐 **회원가입 / 로그인**

#### ✅ 기능 개요

* 사용자는 ID, 비밀번호, 이름을 입력해 회원가입 가능
* 가입 후 로그인 시, 해당 계정의 데이터가 연동됨

#### 🔧 내부 동작

* `UserDefaults`에 `users` 배열을 저장 (`[[String: String]]`)
* 로그인 시, ID/비밀번호로 일치하는 유저 검색
* 성공 시 `currentUserID` 키에 로그인된 ID 저장

#### 🔍 관련 기술

* `UserDefaults` (비영속 저장)
* 입력 검증 및 alert 처리

---

### 2. 🗺️ **지도 기반 킥보드 위치 확인 (마커 표시)**

#### ✅ 기능 개요

* 메인 지도에서 대여 가능한 킥보드를 마커로 표시
* 마커 클릭 시, 배터리 상태 및 대여 버튼이 있는 모달 표시

#### 🔧 내부 동작

* `KickboardEntity`에서 `isRentaled == false`인 항목만 조회
* `NMFMarker`를 통해 위도/경도에 마커 추가
* 마커의 `userInfo`에 킥보드 정보 저장 (ID, 배터리 등)

#### 🔍 관련 기술

* `Naver Maps SDK`, `Core Data`, `SnapKit`
* 모달: `ModalVC`로 present

---

### 3. 🚀 **킥보드 대여**

#### ✅ 기능 개요

* 사용자가 지도에서 마커 클릭 → “대여하기” 클릭 시 킥보드를 대여함

#### 🔧 내부 동작

* `KickboardEntity`의 `isRentaled = true`로 변경
* `RentalHistoryEntity`에 대여 시간과 userID, 킥보드ID 저장
* `RentalManager.shared.checkUserIsRenting()`에서 현재 대여 여부 확인

#### 🔍 관련 기술

* `Core Data` 상태 관리
* `UserDefaults`에서 현재 사용자 ID 불러오기
* 마커 reload 후, 대여 상태에 따라 마커 숨김

---

### 4. 🛑 **킥보드 반납**

#### ✅ 기능 개요

* 사용자가 “반납하기” 버튼 클릭 시, 해당 킥보드를 현재 위치에 반납

#### 🔧 내부 동작

* `isRentaled = false`로 전환
* `latitude`, `longitude`를 현 위치로 갱신
* 해당 RentalHistory의 `returnDate` 저장
* `rentalCount += 1`

#### 🔍 관련 기술

* `CoreLocation`으로 현재 위치 확보
* `fetchRequest` 조건 설정: `"kickboardID == %@ AND returnDate == nil"`
* 마커 재표시

---

### 5. 📍 **킥보드 등록 기능**

#### ✅ 기능 개요

* 사용자가 원하는 주소 입력 → 위치 변환 후 해당 좌표에 킥보드를 등록

#### 🔧 내부 동작

* `CLGeocoder`로 주소 → 위경도 변환
* `KickboardEntity` 새로 생성 후 저장

  * 초기값: 배터리 100%, rentalCount 0, isRentaled = false
* 등록한 유저의 ID(`currentUserID`)와 함께 저장

#### 🔍 관련 기술

* `CoreLocation`, `CLGeocoder`
* `NMFMarker` 표시
* 등록 후 `MapVC.reloadMarkers()` 호출

---

### 6. 🧑‍💼 **마이페이지 - 대여 내역 조회**

#### ✅ 기능 개요

* 내가 언제 킥보드를 빌리고, 언제 반납했는지 확인 가능

#### 🔧 내부 동작

* `RentalHistoryEntity`에서 userID로 필터링
* 날짜, 시간 범위, 총 사용 시간, 요금 계산 후 문자열로 가공

#### 🔍 관련 기술

* `DateFormatter`, 시간 간격 계산
* 요금 = `ceil(사용 시간 / 60) * 100원`

---

### 7. 🧾 **마이페이지 - 내가 등록한 킥보드 목록**

#### ✅ 기능 개요

* 내가 등록한 킥보드의 배터리, 주소, 대여 횟수를 조회

#### 🔧 내부 동작

* `KickboardEntity`에서 `userID == currentUserID` 필터링
* `CLGeocoder().reverseGeocodeLocation()`으로 위경도 → 주소 변환
* `DispatchGroup` 사용해 비동기 주소 변환 완료까지 기다린 뒤 리스트 구성

#### 🔍 관련 기술

* `reverseGeocodeLocation`, `DispatchGroup`, CoreData 필터링

---

### 8. 🚫 **제한 기능 (대여 중일 때)**

#### ✅ 기능 개요

* 대여 중일 경우, 다음 기능은 제한된다:

  * 킥보드 등록 불가
  * 로그아웃 불가
  * 마커 지도에서 숨김

#### 🔧 내부 동작

* 모든 뷰컨트롤러에서 `RentalManager.shared.checkUserIsRenting()` 호출로 판단
* 조건에 따라 `alert` 또는 동작 차단 처리

---

### 9. 📌 **자동 마커 제어 (숨기기 / 보이기)**

#### ✅ 기능 개요

* 대여 중이면 모든 마커 숨김
* 반납 완료 시 `reloadMarkers()`로 다시 표시됨

#### 🔧 내부 동작

```swift
if RentalManager.shared.checkUserIsRenting() {
    print("대여중이라 마커 숨김")
    return
} else {
    // 마커 fetch 후 표시
}
```

---

### 10. 🔓 **로그아웃**

#### ✅ 기능 개요

* 로그아웃 시 로그인화면으로 이동
* 단, 대여 중이면 로그아웃 불가

#### 🔧 내부 동작

```swift
if RentalManager.shared.checkUserIsRenting() {
    // Alert: 반납 후 로그아웃 가능
} else {
    // rootViewController 전환
}
```

---
