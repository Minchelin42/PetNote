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
import SVProgressHUD

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

    let repository = PlaceRepository()
    
    var userLocation: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repository.printLink()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        loadPlaceData()

        getRange()
    }
    
    private func loadPlaceData() {
        SVProgressHUD.show(withStatus: "장소 정보를 불러오는 중입니다")

        callPlaceAPI(page: 1)
    }
    
    private func checkAndUpdateCount(total: Int, page: Int) {
        if UserDefaultManager.shared.dataCount == total {
            self.makeToast("장소 업데이트가 완료되었습니다")
        } else {
            callPlaceAPI(page: page + 1)
        }
    }
    
    private func callPlaceAPI(page: Int) {
        
        var arr: Items = Items(item: [])
        var inputData: [PlaceTable] = []

        PlaceAPI.shared.callRequest(page: page) { status, result, error in
            SVProgressHUD.dismiss()
            
            guard let status = status else {
                print("네트워크 통신 오류")
                self.makeToast("장소 불러오기를 실패하였습니다\n다음에 다시 시도해주세요")
                return
            }
            
            let totalCount = Int(result?.response.body.totalCount ?? "") ?? 0
            
            if UserDefaultManager.shared.dataCount >= totalCount {
                return
            }
            
            if page * 10000 > totalCount {
                UserDefaultManager.shared.dataCount = totalCount
            }
            
            if page == 1 && self.repository.fetch().count > 0 {
                self.repository.deleteAllItem()
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
            
            self.repository.inputItem(inputData)
            
            self.checkAndUpdateCount(total: totalCount, page: page)
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        map.register(PetPlaceAnnotationView.self,forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.register(PlaceClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
 
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

        let filterPlace = repository.fetch()
        
        let annotations = map.annotations
        
        map.removeAnnotations(annotations)
        
        for index in 0..<filterPlace.count {
            
            let category = filterPlace[index].category2
            var imageName = ""
            
            switch category {
            case "동물병원" :
                imageName = Category.hospital
            case "동물약국" :
                imageName = Category.medicine
            case "미용" :
                imageName = Category.beauty
            case "반려동물용품" :
                imageName = Category.shopping
            default:
                imageName = Category.etc
            }
            
            let annotation = CustomAnnotation(title: filterPlace[index].title,
                                              coordinate: CLLocationCoordinate2D(latitude: filterPlace[index].latitude,
                                                                                 longitude: filterPlace[index].longitude),
                                              imageName: imageName)
            
            let distance: CLLocationDistance = MKMapPoint(annotation.coordinate).distance(to: MKMapPoint(map.centerCoordinate));
            
            if distance <= 3000 {
                map.addAnnotation(annotation)
            }
            
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
    
    private func setRegionAndAnnotation(_ center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1500, longitudinalMeters: 1500)
        map.setRegion(region, animated: true)
    }
    
}

extension PlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
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
            let authStatus = manager.authorizationStatus
            self.setLocation(authStatus)
            self.getRange()
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
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
        guard let annotation = annotation as? CustomAnnotation else { return nil }

        return PetPlaceAnnotationView(annotation: annotation, reuseIdentifier: PetPlaceAnnotationView.ReuseID)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let title = view.annotation?.title,
              let latitude = view.annotation?.coordinate.latitude,
              let longitude = view.annotation?.coordinate.longitude else { return }

        let selectPlace = repository.fetch().where {
            $0.title == title ?? "" && $0.latitude == latitude && $0.longitude == longitude
        }
        
        if selectPlace.isEmpty {
            print("위치 정보 없음")
            return
        }
        
        placeInfoView.titleLabel.text = selectPlace[0].title
        placeInfoView.addressLabel.text = selectPlace[0].address
        placeInfoView.infoLabel.text = selectPlace[0].information
        
        placeInfoView.isHidden = false
    }
}
