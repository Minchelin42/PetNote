//
//  ProfileView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/21.
//

import UIKit
import SnapKit

class ProfileInfoView: UIView {
    
    let profileButton = ProfileButton()
    let editButton = CameraButton()
    
    let nameLabel = UILabel()
    let birthLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        addSubview(profileButton)
        addSubview(editButton)
        addSubview(nameLabel)
        addSubview(birthLabel)
    }
    
    func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(80)
        }
        
        editButton.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.leading).offset(56)
            make.bottom.equalTo(profileButton.snp.bottom)
            make.size.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(33)
            make.leading.equalTo(profileButton.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(15)
            
        }
        
        birthLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(33)
        }
    }
    
    func configureView() {
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 40
        
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 15
        editButton.setImage(UIImage(named: "pencil"), for: .normal)
        editButton.contentVerticalAlignment = .fill
        editButton.contentHorizontalAlignment = .fill
        editButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        nameLabel.text = "루비"
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        birthLabel.text = "🎂 2010-03-05"
        birthLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

