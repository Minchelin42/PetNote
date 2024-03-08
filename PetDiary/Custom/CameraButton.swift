//
//  CameraButton.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/08.
//

import UIKit

class CameraButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.green
        setImage(UIImage(systemName: "camera"), for: .normal)
        tintColor = .white
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
