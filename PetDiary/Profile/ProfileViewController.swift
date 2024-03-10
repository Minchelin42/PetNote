//
//  ProfileViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/07.
//

import UIKit

class ProfileViewController: UIViewController {

    private let mainView = ProfileView()
    
    let viewModel = ProfileViewModel()
    
    var petWeight: Double = 0.0
    
    //화면 아무 곳이나 눌렀을 때 키보드 내려감
    lazy var tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGesture)
        
        mainView.nameTextField.delegate = self
        mainView.weightTextField.delegate = self
        
        mainView.cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        
        mainView.registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        
        mainView.genderButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        
        mainView.birthButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        
        mainView.meetButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)

        mainView.nameTextField.addDoneButton(doneAction: #selector(inputName))
        mainView.weightTextField.addDoneButton(doneAction: #selector(inputWeight))
        
        viewModel.name.bind { name in
            if let name {
                self.mainView.nameTextField.text = name
            }
            self.viewModel.checkInputDataStatus()
        }
        
        viewModel.gender.bind { gender in
            if let gender {
                self.mainView.genderButton.setTitle( gender ? "남아" : "여아", for: .normal)
                self.mainView.genderButton.setTitleColor(Color.font, for: .normal)
            }
            self.viewModel.checkInputDataStatus()
        }
        
        viewModel.birth.bind { birth in
            if let birth {
                self.mainView.birthButton.setTitle(birth.changeDateFormat(), for: .normal)
                self.mainView.birthButton.setTitleColor(Color.font, for: .normal)
            }
            self.viewModel.checkInputDataStatus()
        }
        
        viewModel.firstMeet.bind { firstMeet in
            if let firstMeet {
                self.mainView.meetButton.setTitle(firstMeet.changeDateFormat(), for: .normal)
                self.mainView.meetButton.setTitleColor(Color.font, for: .normal)
            }
            self.viewModel.checkInputDataStatus()
        }
        
        viewModel.weight.bind { weight in
            if let weight {
                self.mainView.weightTextField.text = "\(weight)kg"
            }
            self.viewModel.checkInputDataStatus()
        }
        
        viewModel.checkInputData.bind { value in
            if value {
                self.mainView.registerButton.backgroundColor = Color.darkGreen
            } else {
                self.mainView.registerButton.backgroundColor = Color.darkGray
            }
        }

    }
    
    @objc func cameraButtonClicked() {
        let vc = CameraBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.selectImage = { image in
            print(image)
            if let image = image {
                self.mainView.profileButton.setImage(image, for: .normal)
            }
        }
        self.present(vc, animated: false)
    }
    
    @objc func genderButtonClicked() {
        let vc = GenderBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.viewModel.gender.value = self.viewModel.gender.value
        vc.selectGender = { gender in
            self.viewModel.gender.value = gender

            print("profileView: \(self.viewModel.gender.value)")
        }
        self.present(vc, animated: false)
    }
    
    @objc func dateButtonClicked(_ sender: UIButton) {
        let vc = DateBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.dateType = sender.datetype!
        vc.selectDate = { date in
            if sender.datetype! == .birth {
                self.viewModel.birth.value = date
            } else {
                self.viewModel.firstMeet.value = date
            }
        }
        self.present(vc, animated: false)
    }
    
    @objc func registerButtonClicked() {
        print(#function)
        viewModel.repository.printLink()
        print(viewModel.name.value, viewModel.birth.value, viewModel.firstMeet.value, viewModel.gender.value, viewModel.weight.value)
        viewModel.registerButtonClicked.value = ()
        if self.viewModel.checkInputData.value {
            if let image = self.mainView.profileButton.currentImage {
                saveImageToDocument(image: image, filename: "\(viewModel.name.value)")
            }
        }
    }
    
    @objc func inputWeight() {
        if let weight = Double(mainView.weightTextField.text!) {
            self.viewModel.weight.value = weight
            mainView.weightTextField.resignFirstResponder()
        } else {
            self.viewModel.weight.value = nil
            mainView.weightTextField.resignFirstResponder()
        }
    }
    
    @objc func inputName() {
        if let name = mainView.nameTextField.text {
            self.viewModel.name.value = name
            mainView.nameTextField.resignFirstResponder()
        } else {
            self.viewModel.name.value = nil
            mainView.nameTextField.resignFirstResponder()
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    //return 클릭 시 키보드가 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.viewModel.name.value = textField.text!
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
}

#Preview {
    ProfileViewController()
}
