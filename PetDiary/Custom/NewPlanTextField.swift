//
//  NewPlanTextField.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit

class NewPlanTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .systemFont(ofSize: 13, weight: .medium)
        textColor = .black
        textAlignment = .left
        backgroundColor = .clear
        tintColor = Color.darkGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

