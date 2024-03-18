//
//  PlaceViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/16.
//

import UIKit
import SnapKit
import MapKit

class PlaceViewController: UIViewController {

    let map = MKMapView()
    let button = {
       let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .red
        return button
    }() //내위치 버튼으로 수정
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()

    }
    
    func configureHierarchy() {
        view.addSubview(map)
        view.addSubview(button)
    }
    
    func configureLayout() {
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configureView() {
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

        button.addTarget(self, action: #selector(buttonclick), for: .touchUpInside)

    }
    
    @objc func buttonclick() {
        
        // 중심값(필수): 위, 경도
        let center = CLLocationCoordinate2D(latitude: 37.27,
                                            longitude: 127.43)

        // 영역을 확대 및 축소를 한다. (값이 낮을수록 화면을 확대/높으면 축소)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)

        // center를 중심으로 span 영역만큼 확대/축소 해서 보여줌
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        
        map.setRegion(region, animated: false)
        createAnnotation()
    }
    
    func createAnnotation() {
        let annotation = CustomAnnotation(title: "Here",
                                          coordinate: CLLocationCoordinate2D(latitude: 37.2719952,
                                                                             longitude: 127.4348221))
        
        annotation.imageName = "MapPin"
        
        
        map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        
        map.addAnnotation(annotation)
    }
    
    
    func setupAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return map.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self), for: annotation)
    }
    
}

extension PlaceViewController: MKMapViewDelegate {
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
