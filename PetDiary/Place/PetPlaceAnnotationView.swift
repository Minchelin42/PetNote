//
//  PetAnnotationView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/30.
//

import MapKit


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
        displayPriority = .defaultLow
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
