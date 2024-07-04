# 📔 페트와 노트 : 반려동물과 나만의 기록 노트
<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/93bd4138-078f-45ed-b097-c32943fafa79" alt="IMG_5119" width="100" height="100">

### 반려동물과 나, 둘만의 기록을 남기고 관리할 수 있는 반려동물 전용 기록 앱 [AppStore](https://apps.apple.com/kr/app/id6479473893)  
- iOS 1인 개발
- 최소 버전 iOS 16.0 
- 개발 기간 2024.03.09 ~ 2024.03.26 (2주)




## 📝 주요 기능
- 반려동물 관련 할 일 추가 및 수정
- Local Notification을 이용한 할 일 알림
- 사용자 현위치를 기반한 반려동물 동반 가능 장소 정보 제공
- 반려동물 프로필 수정


## ⚒️ 사용 기술 및 라이브러리 
 `MVC`
 `MVVM`
 `Alamofire`
 `MapKit`
 `Realm`
 `IQKeyboardManagerSwift`
 `SwipeCellKit`
 `FSCalendar`
 `Toast`
 `FirebaseAnalytics`
 `FirebaseCrashlytics`
 `SnapKit`
 `UIKit`
 `Swift`
 `CodeBaseUI`

## ⚒️ 기술 적용

- **Realm Repository Pattern**을 통해 데이터 접근 로직을 추상화하여 DB와의 의존성을 줄이고, 코드 유지보수성 향상 
- **Clustering**을 통해 렌더링 시간 감소 및 사용자 경험 개선
- **Custom Observable**을 통해 **MVVM**을 구현하여 데이터 바인딩을 효율적으로 관리
- **Firebase Analytics, Crashlytics**를 통해 사용자 분석과 오류 모니터링을 진행하여 앱의 안정성 및 품질을 향상
- **Alamofire**를 통해 HTTP 요청 관리
- **Local Notification**을 적용하여 사용자에게 알림을 실시간으로 전송
- **final**을 통해 클래스와 메서드의 상속과 오버라이딩을 제한하여 코드의 안정성 강화
- **CLAuthorizationStatus**를 이용하여 사용자의 위치 서비스에 대한 접근 권한 실시간 감지

## 📷 스크린샷
|홈 화면|할 일 추가|수정 및 삭제|
|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/efafd45e-1916-4082-b20b-4e109bcd489d" width="200" height="390"/>|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/63444603-45c9-47fb-b068-08d4721205d8" width="200" height="390"/>|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/833a1c50-098d-417e-9dc2-a959918904d4" width="200" height="390"></img>|


|주변 지도(클러스터링)|장소에 관한 상세정보|프로필 수정|
|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/122435e5-67e0-4eec-bcfe-7e84501a0a4e" width="200" height="390"/>|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/ae29164f-39a3-4a58-b1ee-1babbe720f40" width="200" height="390"/>|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/1cf2a0f8-8bbb-42df-9a25-b9af6a9ac0bb" width="200" height="390"/>|

## 💥 트러블슈팅
### 지도 내에서 과도하게 많은 Annotation이 생성되는 것에 대한 문제
**MapKit의 Clustering을 도입한 CustomAnnotation을 구현하여 렌더링 시간 감소 및 Map 사용성 향상**

|Clustering 적용 전|Clustering 적용 후|
|:---:|:---:|
|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/43f14f5d-4f6f-4656-9d5f-724e1ac84f7a" width="200" height="390"/>|<img src="https://github.com/Minchelin42/PetDiary/assets/126135097/e65252a7-7796-48bb-95c6-9cb7405a8df3" width="200" height="390"/>|

```Swift
class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, imageName: String) {
        self.title = title
        self.coordinate = coordinate
        self.imageName = imageName
    }
}

class PetPlaceAnnotationView: MKAnnotationView {
    static let ReuseID = "petAnnotation"
    
    let customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "petPlace"
        
        configUI()
    }

    //configUI
}

```

## 🗓️ 업데이트 내역

### v 1.0.1   
> 24.04.14 지도 클러스터링    
### v 1.0.0  
> 24.03.26 앱스토어 출시
