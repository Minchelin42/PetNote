//
//  CompleteButton.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit

class CompleteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = Color.darkGreen
        setTitle("완료", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
