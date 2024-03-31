//
//  PlaceClusterAnnotationView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/30.
//

import MapKit

class PlaceClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {

            if cluster.memberAnnotations.count > 1 {
                image = drawPlaceCount(count: cluster.memberAnnotations.count, color: Color.darkGreen!)
            }
            
            displayPriority = .defaultLow

        }
    }

    private func drawPlaceCount(count: Int, color: UIColor) -> UIImage {
        return drawRatio(0, to: count, fractionColor: nil, wholeColor: color)
    }
    
    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: Color.darkGray,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }

    
    private func count(_ placeType: String) -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }

        return cluster.memberAnnotations.filter { member -> Bool in
            guard let place = member as? CustomAnnotation else {
                fatalError("Found unexpected annotation type")
            }
            
            print("place.imageName: ",place.imageName ?? "", "placeType", placeType)
            print(place.imageName == placeType)
            
            return (place.imageName == placeType)
        }.count

    }
    
}
