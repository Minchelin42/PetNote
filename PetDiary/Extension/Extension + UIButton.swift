//
//  Extension + UIButton.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit


enum DateType {
    case firstMeet
    case birth
}

private var datetypeKey: UInt8 = 0

extension UIButton {
    var datetype: DateType? {
        get {
            return objc_getAssociatedObject(self, &datetypeKey) as? DateType
        }
        set {
            objc_setAssociatedObject(self, &datetypeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
