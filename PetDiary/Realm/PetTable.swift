//
//  File.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import Foundation
import RealmSwift

final class PetTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var gender: Bool
    @Persisted var birth: Date
    @Persisted var meet: Date
    @Persisted var weight: Double
    
    convenience init(name: String, gender: Bool, birth: Date, meet: Date, weight: Double) {
        self.init()
        self.name = name
        self.gender = gender
        self.birth = birth
        self.meet = meet
        self.weight = weight
    }
}
