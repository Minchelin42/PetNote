//
//  PlanTable.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/13.
//

import Foundation
import RealmSwift

final class PlanTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String
    @Persisted var date: Date
    @Persisted var alarm: Bool
    @Persisted var time: Date?
    @Persisted var registerDate: Date
    @Persisted var firstDate: Date
    @Persisted var lastDate: Date?
    @Persisted var clear: Bool
    @Persisted var pet: ObjectId
    
    convenience init(title: String, memo: String, date: Date, alarm: Bool, time: Date?, registerDate: Date, firstDate: Date, lastDate: Date?, pet: ObjectId) {
        self.init()
        self.title = title
        self.memo = memo
        self.date = date
        self.alarm = alarm
        self.time = time
        self.registerDate = registerDate
        self.firstDate = firstDate
        self.lastDate = lastDate
        self.pet = pet
        self.clear = false
    }
}
