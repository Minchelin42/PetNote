//
//  PlaceTable.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/19.
//

import Foundation
import RealmSwift

final class PlaceTable: Object {
    @Persisted var title: String
    @Persisted var category1: String
    @Persisted var category2: String
    @Persisted var information: String
    @Persisted var tel: String?
    @Persisted var address: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    convenience init(title: String, category1: String, category2: String, information: String, tel: String? = nil, address: String, latitude: Double, longitude: Double) {
        self.init()
        self.title = title
        self.category1 = category1
        self.category2 = category2
        self.information = information
        self.tel = tel
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
