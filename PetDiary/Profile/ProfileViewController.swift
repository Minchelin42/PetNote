//
//  ProfileViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/07.
//

import UIKit

class ProfileViewController: UIViewController {

    private let mainView = ProfileView()
    
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

    }
}

extension ProfileViewController: UITextFieldDelegate {
    //return 클릭 시 키보드가 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    ProfileViewController()
}
