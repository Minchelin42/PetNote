//
//  ViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var arr: Items = Items(item: [])
//        
//        PlaceAPI.shared.callRequest { result, error in
//            arr = (result?.response.body.items)!
//            
//            print(arr.item[0])
//            print(arr.item[9999])
//        }
//        
        
        //위도 경도 추출
        let str = "N37.64454276, E126.886336"
        let arr = str.split(separator: ", ")
        print(arr)
        
        var letitude = String(arr[0].dropFirst())
        var longitude = String(arr[1].dropFirst())
        print(letitude, longitude)
        
        // Do any additional setup after loading the view.
    }


}

