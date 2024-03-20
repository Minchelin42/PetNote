//
//  PlaceViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/16.
//

import UIKit
import SnapKit
import MapKit
import RealmSwift
import Toast

enum Category {
    static let shopping = "Goods"
    static let medicine = "Medichine"
    static let hospital = "Hospital"
    static let beauty = "Beauty"
    static let etc = "Etc"
}

class PlaceViewController: UIViewController {

    let map = MKMapView()
    let searchButton = {
       let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = Color.green
        button.setTitle("내위치로 이동", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    let placeInfoView = PlaceInfoView()
    
    lazy var locationManager = CLLocationManager()

    var arr: Items = Items(item: [])
    
    let repository = PlaceRepository()
    
    var userLocation: CLLocationCoordinate2D!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repository.printLink()

        configureHierarchy()
        configureLayout()
        configureView()
        
        if repository.fetch().isEmpty {
            loadPlaceData()
        }
        
        getRange()
    }

    func loadPlaceData() {
        
        DispatchQueue.global().async {
            var arr: Items = Items(item: [])
            var inputData: [PlaceTable] = []

            print("여기 시작", Date.now)
            PlaceAPI.shared.callRequest { status, result, error in

                guard let status = status else {
                    print("네트워크 통신 오류")
                    var style = ToastStyle()
                    style.backgroundColor = Color.lightGreen!
                    style.messageColor = .white
                    style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
                    style.messageAlignment = .center
                    self.view.makeToast("장소 불러오기를 실패하였습니다\n다음에 다시 시도해주세요", duration: 10.0, position: .bottom, style: style)
                    return
                }
                
                arr = (result?.response.body.items)!
            
                for index in 0..<arr.item.count {
                    let item = arr.item[index]

                    let inputPlace = PlaceTable(title: item.title, category1: item.category1, category2: item.category2, information: item.description, tel: "", address: item.address, latitude: 0.0, longitude: 0.0)
                        
                    
                    let coordinates = self.getLocation(item.coordinates)
                    inputPlace.latitude = coordinates[0]
                    inputPlace.longitude = coordinates[1]
                    
                    if inputPlace.information.contains("반려동물 동반불가") { continue }
                    
                    inputData.append(inputPlace)
                }

                print("여기 반복문 끝", Date.now)

                self.repository.inputItem(inputData)
                
                var style = ToastStyle()
                style.backgroundColor = Color.lightGreen!
                style.messageColor = .white
                style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
                self.view.makeToast("장소 업데이트가 완료되었습니다", duration: 2.0, position: .bottom, style: style)
            }
        }
    }
    
    
    private func configureHierarchy() {
        view.addSubview(map)
        view.addSubview(searchButton)
        view.addSubview(placeInfoView)
    }
    
    private func configureLayout() {
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(166)
            make.height.equalTo(43)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        placeInfoView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(155)
        }
    }
    
    private func configureView() {
        map.mapType = MKMapType.standard
        
        // 줌 가능 여부
        map.isZoomEnabled = true
        // 이동 가능 여부
        map.isScrollEnabled = true
        // 각도 조절 가능 여부 (두 손가락으로 위/아래 슬라이드)
        map.isPitchEnabled = true
        // 회전 가능 여부
        map.isRotateEnabled = true
        // 위치 사용 시 사용자의 현재 위치를 표시
        map.showsUserLocation = true
        
        map.delegate = self
        locationManager.delegate = self
        
        map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        

        searchButton.addTarget(self, action: #selector(searchButtonclick), for: .touchUpInside)
        
        placeInfoView.layer.cornerRadius = 20
        placeInfoView.isHidden = true

    }
    
    @objc func searchButtonclick() {
        setRegionAndAnnotation(self.userLocation)
        getRange()
    }
    
    private func getRange() {
        
        let center = map.region.center
        let span = map.region.span
       
        
        let farSouth = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let farNorth = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let farEast = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
        let farWest = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        
        let minimumLatitude: Double = farSouth.coordinate.latitude as Double
        let maximumLatitude: Double = farNorth.coordinate.latitude as Double
        let minimumlongtitude: Double = farWest.coordinate.longitude as Double
        let maximumLongitude: Double = farEast.coordinate.longitude as Double

        let filterPlace = repository.fetch().where {
                ($0.latitude >= minimumLatitude) && ($0.latitude <= maximumLatitude) && ($0.longitude >= minimumlongtitude) && ($0.longitude <= maximumLongitude)
            }

        let annotations = map.annotations
        
        map.removeAnnotations(annotations)
        
        for index in 0..<filterPlace.count {
            let annotation = CustomAnnotation(title: filterPlace[index].title,
                                              coordinate: CLLocationCoordinate2D(latitude: filterPlace[index].latitude,
                                                                                 longitude: filterPlace[index].longitude))
            
            let category = filterPlace[index].category2
            
            switch category {
            case "동물병원" : 
                annotation.imageName = Category.hospital
            case "동물약국" :  
                annotation.imageName = Category.medicine
            case "미용" :  
                annotation.imageName = Category.beauty
            case "반려동물용품" :  
                annotation.imageName = Category.shopping
            default:  
                annotation.imageName = Category.etc
            }
            
            map.addAnnotation(annotation)
            
            if index > 30 { return }
        }
        

    }
    
    private func getLocation(_ coordinates: String) -> [Double] {
        //위도 경도 추출

            let arr = coordinates.split(separator: ", ")
            
            let letitude = String(arr[0].dropFirst())
            let longitude = String(arr[1].dropFirst())
        
        if let letitude = Double(letitude), let longitude = Double(longitude) {
            return [letitude, longitude]
        } else { return [0, 0] }
    }
    
    private func setupAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return map.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self), for: annotation)
    }
    
    private func setLocation(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("사용자가 위치권한에 대한 설정을 안한 경우")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("사용자가 위치 설정을 거부한 상태")
            self.goToSetting()
            setDefaultLocation()
        case .restricted:
            print("위치 서비스 활성화가 제한된 상태")
            self.goToSetting()
            setDefaultLocation()
        case .authorizedWhenInUse:
            print("앱을 사용중일 때 위치서비스 이용 허용함")
            locationManager.startUpdatingLocation()
            self.searchButton.isHidden = false
        default:
            print("default")
        }
    }
    
    private func goToSetting() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "설정 > 개인정보보호 > 위치 설정을 허용하시면 현위치 주변 정보가 검색 가능합니다", preferredStyle: .alert)
                let setting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                    if let setting = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(setting)
                    }
                }
                alert.addAction(setting)
                present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(_ center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        map.setRegion(region, animated: true)
    }
    
}

extension PlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            self.userLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            setRegionAndAnnotation(self.userLocation)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("성공적으로 못가져옴")
        setDefaultLocation()
       
    }
    
    func setDefaultLocation() {
        self.userLocation = CLLocationCoordinate2D(latitude: 37.547913, longitude: 127.07461)
        setRegionAndAnnotation(self.userLocation)
        self.searchButton.isHidden = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            print(#function)
            let authStatus = manager.authorizationStatus
            self.setLocation(authStatus)
            self.getRange()
        }
    }
}

extension PlaceViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
         getRange()
         self.placeInfoView.isHidden = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?

        if let customAnnotation = annotation as? CustomAnnotation {
            annotationView = setupAnnotationView(for: customAnnotation, on: mapView)
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let title = view.annotation?.title,
        let latitude = view.annotation?.coordinate.latitude,
        let longitude = view.annotation?.coordinate.longitude else { return }
        
        if latitude == self.userLocation.latitude && longitude == self.userLocation.longitude {
            
            print("User Annotation")
            return
            
        }
        
        let selectPlace = repository.fetch().where {
            $0.title == title ?? "" && $0.latitude == latitude && $0.longitude == longitude
        }
        
        print(selectPlace[0])
        
        placeInfoView.titleLabel.text = selectPlace[0].title
        placeInfoView.addressLabel.text = selectPlace[0].address
        placeInfoView.infoLabel.text = selectPlace[0].information
        
        placeInfoView.isHidden = false
    }
}

class CustomAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class CustomAnnotationView: MKAnnotationView {

    let customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? CustomAnnotation else { return }

        guard let imageName = annotation.imageName,
              let image = UIImage(named: imageName) else { return }
        
        customImageView.image = image
    }
    

    override func layoutSubviews() {
    super.layoutSubviews()
        bounds.size = CGSize(width: 30, height: 30)
        centerOffset = CGPoint(x: 0, y: 15)
    }
}
