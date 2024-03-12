//
//  Extension + TextField.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit

extension UITextField {
    func addDoneButton(doneAction: Selector?) {

        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "완료", style: .done, target: ProfileViewController(), action: doneAction)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func underlined(viewWidth: CGFloat, viewHeight: Int, color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + CGFloat(viewHeight), width: viewWidth, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
}

