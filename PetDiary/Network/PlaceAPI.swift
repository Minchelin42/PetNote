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

    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    func callRequest(page: Int, completionHandler: @escaping((Int?, Place?, AFError?) -> Void)) {
        let url = "http://api.kcisa.kr/openapi/API_TOU_050/request?serviceKey=\(APIKey.serviceKey)&pageNo=\(page)"
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Place.self) { response in
            
            switch response.result {
            case .success(let success):
                completionHandler(response.response?.statusCode, success, nil)
            case .failure(let failure):
                completionHandler(nil, nil, failure)
                print(failure)
            }
        }
    }
    
    
}
