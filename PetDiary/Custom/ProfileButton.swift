//
//  ProfileButton.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/08.
//

import UIKit

class ProfileButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.borderColor = Color.lightGreen?.cgColor
        layer.borderWidth = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
