//
//  ViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/07.
//

import UIKit

class ViewController: UIViewController {
    
    let repository = PlaceRepository()
    
    let place = PlaceInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(place)
        
        place.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(155)
        }
        
        
        place.addressLabel.text = "Dafdklfjadlf"
        
//        var arr: Items = Items(item: [])
//        var inputData: [PlaceTable] = []
//        
//        repository.deleteAllItem()
//        repository.printLink()
//        
//        
//        print("여기 시작", Date.now)
//        PlaceAPI.shared.callRequest { result, error in
//            arr = (result?.response.body.items)!
//        
//            for index in 0..<arr.item.count {
//                let item = arr.item[index]
//
//                var inputPlace = PlaceTable(title: item.title, category1: item.category1, category2: item.category2, information: item.description, tel: "", address: item.address, latitude: 0.0, longitude: 0.0)
//                    
//                
//                let coordinates = self.getLocation(item.coordinates)
//                inputPlace.latitude = Double(coordinates[0]) ?? 0
//                inputPlace.longitude = Double(coordinates[1]) ?? 0
//                
//                if inputPlace.information.contains("반려동물 동반불가") { continue }
//                
//                inputData.append(inputPlace)
//            }
//
//            print("여기 반복문 끝", Date.now)
//            self.repository.inputItem(inputData)
//        }
    }
    
    private func getLocation(_ coordinates: String?) -> [String] {
        //위도 경도 추출
        if let coordinates = coordinates {
            let arr = coordinates.split(separator: ", ")
//            print(arr)
            
            let letitude = String(arr[0].dropFirst())
            let longitude = String(arr[1].dropFirst())
//            print(letitude, longitude)
            return [letitude, longitude]
        } else {
            return ["0.0", "0.0"]
        }
    }
    
}
    

    
    //위도 경도 추출
    //        let str = "N37.64454276, E126.886336"
    //        let arr = str.split(separator: ", ")
    //        print(arr)
    //
    //        var letitude = String(arr[0].dropFirst())
    //        var longitude = String(arr[1].dropFirst())
    //        print(letitude, longitude)
    
    // Do any additional setup after loading the view.



#Preview {
    ViewController()
}
