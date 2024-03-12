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
    
    convenience init(title: String, memo: String, date: Date, alarm: Bool, time: Date?) {
        self.init()
        self.title = title
        self.memo = memo
        self.date = date
        self.alarm = alarm
        self.time = time
    }
}
