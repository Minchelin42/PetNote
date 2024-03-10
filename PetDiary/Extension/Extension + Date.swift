//
//  Extension + Date.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/10.
//

import Foundation

extension Date {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
