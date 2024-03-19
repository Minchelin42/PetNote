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

class PlaceViewController: UIViewController {

    let map = MKMapView()
    let searchButton = {
       let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = Color.green
        button.setTitle("현위치에서 검색하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()

    var arr: Items = Items(item: [])
    
    let repository = PlaceRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        
        getRange()
    }

    func loadPlaceData() {
        
        var arr: Items = Items(item: [])
        
        PlaceAPI.shared.callRequest { result, error in
            arr = (result?.response.body.items)!
            
            for index in 0..<arr.item.count {
                let item = arr.item[index]
                
                var inputPlace = PlaceTable(title: "", category1: "" , category2: "", information: "", tel: "", address: "", latitude: 0.0, longitude: 0.0)
                
                if let title = item["title"]!,
                   let category1 = item["category1"]!,
                   let category2 = item["category2"]!,
                   let information = item["description"]!,
                   let address = item["address"]!,
                   let coordinate = item["coordinates"]!{

                   inputPlace.title = title
                    inputPlace.category1 = category1
                    inputPlace.category2 = category2
                    inputPlace.information = information
                    inputPlace.address = address
                    
                    let coordinates = self.getLocation(coordinate)
                    inputPlace.latitude = Double(coordinates[0])!
                    inputPlace.longitude = Double(coordinates[1])!
                } else {
                    print("어떠한 정보가 누락되었음")
                }
                
                if let tel = item["tel"]! {
                    inputPlace.tel = tel
                } else {
                    print("tel 정보 없음")
                }
                
                self.repository.createItem(inputPlace)
 
            }
        }
    }
    
    
    private func configureHierarchy() {
        view.addSubview(map)
        view.addSubview(searchButton)
    }
    
    private func configureLayout() {
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(166)
            make.height.equalTo(43)
            make.bottom.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
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
        
//        buttonclick()

        let center = CLLocationCoordinate2D(latitude: 37.64454276,
                                            longitude: 126.886336)

        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
    
        let region = MKCoordinateRegion(center: center, span: span)
        
        map.setRegion(region, animated: false)
        
        map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        

        searchButton.addTarget(self, action: #selector(searchButtonclick), for: .touchUpInside)

    }
    
    @objc func searchButtonclick() {
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
            
            annotation.imageName = "MapPin"
            map.addAnnotation(annotation)
        }
        

    }
    
    private func getLocation(_ coordinates: String?) -> [String] {
        //위도 경도 추출
        if let coordinates = coordinates {
            let arr = coordinates.split(separator: ", ")
            print(arr)
            
            var letitude = String(arr[0].dropFirst())
            var longitude = String(arr[1].dropFirst())
            print(letitude, longitude)
            return [letitude, longitude]
        } else {
            return ["0.0", "0.0"]
        }
    }

    private func createRealmAnnotation() {
        
        var list = repository.fetch()

        map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        
        for index in 0..<list.count {
            let annotation = CustomAnnotation(title: list[index].title,
                                              coordinate: CLLocationCoordinate2D(latitude: list[index].latitude,
                                                                                 longitude: list[index].longitude))
            
            annotation.imageName = "MapPin"
            map.addAnnotation(annotation)
        }
    }
    
    private func setupAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return map.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self), for: annotation)
    }
    
}

extension PlaceViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
         getRange()
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
        let vc = DateBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.dateType = .plan
        vc.selectTime = { time in
            print(time)
        }
        present(vc, animated: true)
        
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
            make.size.equalTo(25)
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
        bounds.size = CGSize(width: 25, height: 25)
        centerOffset = CGPoint(x: 0, y: 12.5)
    }
}
