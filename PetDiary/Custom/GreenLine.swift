//
//  GreenLine.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit

class GreenLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.darkGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
