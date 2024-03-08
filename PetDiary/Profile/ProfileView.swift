//
//  ProfileView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {

    let profileButton = ProfileButton()
    let cameraButton = CameraButton()
    
    let nameLabel = ProfileLabel()
    let nameTextField = ProfileInputTextField()

    let genderLabel = ProfileLabel()
    let genderButton = ProfileInputButton()
    
    let birthLabel = ProfileLabel()
    let birthButton = ProfileInputButton()
    
    let meetLabel = ProfileLabel()
    let meetButton = ProfileInputButton()
    
    let weightLabel = ProfileLabel()
    let weightTextField = ProfileInputTextField()
    
    let registerButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = Color.darkGray
        button.setTitle("등록하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        return button
    }()
    

  
    override func configureHierarchy() {
        addSubview(profileButton)
        addSubview(cameraButton)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(genderLabel)
        addSubview(genderButton)
        addSubview(birthLabel)
        addSubview(birthButton)
        addSubview(meetLabel)
        addSubview(meetButton)
        addSubview(weightLabel)
        addSubview(weightTextField)
        addSubview(registerButton)
      
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).inset(50)
            make.size.equalTo(160)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.top).inset(100)
            make.centerX.equalTo(profileButton.snp.trailing).inset(20)
            make.size.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(40)
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(9)
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        genderButton.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
        birthLabel.snp.makeConstraints { make in
            make.top.equalTo(genderButton.snp.bottom).offset(9)
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        birthButton.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
        meetLabel.snp.makeConstraints { make in
            make.top.equalTo(birthButton.snp.bottom).offset(9)
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        meetButton.snp.makeConstraints { make in
            make.top.equalTo(meetLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(meetButton.snp.bottom).offset(9)
            make.leading.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(45)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(35)
            make.height.equalTo(45)
        }
        
    }
    
    override func configureView() {
        profileButton.layer.cornerRadius = 80
        profileButton.setImage(UIImage(named: "profile"), for: .normal)
        cameraButton.layer.cornerRadius = 25
        
        nameLabel.text = "이름"
        nameTextField.placeholder = "이름을 입력해주세요"

        genderLabel.text = "성별"
        genderButton.setTitle("성별을 입력해주세요", for: .normal)
        birthLabel.text = "태어난 날"
        birthButton.setTitle("생일을 입력해주세요", for: .normal)
        meetLabel.text = "처음 만난 날"
        meetButton.setTitle("처음 만난 날을 입력해주세요", for: .normal)
        weightLabel.text = "몸무게"
        weightTextField.placeholder = "몸무게(kg)를 입력해주세요"
    }


}


