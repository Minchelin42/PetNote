//
//  PlaceAPI.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/16.
//

import Foundation
import Alamofire

class PlaceAPI {
    
    static let shared = PlaceAPI()
    
    let url = "http://api.kcisa.kr/openapi/API_TOU_050/request?serviceKey=\(APIKey.serviceKey)"
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    func callRequest(completionHandler: @escaping((Place?, AFError?) -> Void)) {
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Place.self) { response in
            
            switch response.result {
            case .success(let success):
                completionHandler(success, nil)
//                dump(success)
            case .failure(let failure):
                completionHandler(nil, failure)
                print(failure)
            }
        }
    }
    
    
}
