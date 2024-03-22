//
//  UserDefaultManager.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/21.
//

import Foundation

class UserDefaultManager {
    
    private init() { }
    
    static let shared = UserDefaultManager()

    let ud = UserDefaults.standard
    
    enum UDKey: String {
        case nowPet
    }

    var nowPet: String {
        get {
            ud.string(forKey: UDKey.nowPet.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: UDKey.nowPet.rawValue)
        }
    }

}
