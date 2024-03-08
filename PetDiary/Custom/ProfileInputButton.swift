//
//  ProfileInputButton.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/08.
//

import UIKit

class ProfileInputButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = Color.lightGray
        setTitleColor(Color.darkGray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
