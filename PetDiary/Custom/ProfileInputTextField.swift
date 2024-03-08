//
//  ProfileInputTextField.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/08.
//

import UIKit

class ProfileInputTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = Color.lightGray
        textColor = Color.font
        textAlignment = .center
        font = .systemFont(ofSize: 14, weight: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//
//
//#Preview {
//    ProfileViewController()
//}
