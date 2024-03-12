//
//  NewPlanLabel.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit

class NewPlanLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = Color.darkGray
        font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
