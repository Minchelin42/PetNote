//
//  ProfileLabel.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/08.
//

import UIKit

class ProfileLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = Color.font
        font = .systemFont(ofSize: 13, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
