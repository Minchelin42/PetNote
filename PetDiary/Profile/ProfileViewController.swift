//
//  ProfileViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/07.
//

import UIKit

enum ProfileType {
    case new
    case edit
}

class ProfileViewController: UIViewController {

    private let mainView = ProfileScrollView()
    
    let viewModel = ProfileViewModel()

    //화면 아무 곳이나 눌렀을 때 키보드 내려감
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
    
    var type = ProfileType.new
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        inputName()
        inputWeight()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGesture)

        mainView.scrollView.delegate = self
        mainView.scrollView.bounces = false
        mainView.nameTextField.delegate = self
        mainView.weightTextField.delegate = self
        
        navigationSetting()
        
        bind()
        registerAction()
        addAction()

        if type == .new {
            navigationItem.title = "반려동물 정보 등록"
        } else {
            navigationItem.title = "반려동물 정보 수정"
        }

        if type == .edit {
            loadProfile()
        }

    }
    
    @objc func leftButtonItemClicked() {
        navigationController?.popViewController(animated: true)
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
            self.viewModel.name.value = ""
            mainView.nameTextField.resignFirstResponder()
        }
    }
    
    private func navigationSetting() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.darkGreen]
        UINavigationBar.appearance().tintColor = Color.darkGreen
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftButtonItemClicked))
    }
    
    private func loadProfile() {
        
        self.viewModel.findNowPet()

        self.mainView.profileButton.setImage(loadImageToDocument(filename: "\(self.viewModel.petID.value)"), for: .normal)
       
    }
    
    private func bind() {
        viewModel.name.bind { name in
            self.mainView.nameTextField.text = name
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
        
        viewModel.checkDuplicate.bind { value in
            if value { //중복인 경우
                self.makeToast("동일한 이름의 반려동물이 존재합니다")
                self.viewModel.name.value = ""
                self.mainView.nameTextField.text = ""
            }
        }
        
        if type == .edit {
            viewModel.editButtonClicked.bind { _ in
                self.viewModel.repository.printLink()
                self.viewModel.compareDate()
                
                if self.viewModel.checkDate.value { //생일보다 처음 만난 날이 먼저일 경우
                    self.makeToast("처음 만난 날보다 생일이 이른 날짜여야합니다")
                    self.viewModel.checkInputData.value = false
                    
                    return
                }

                guard let pet = self.viewModel.nowPet.value else { return }
                
                if !self.viewModel.name.value.elementsEqual(UserDefaultManager.shared.nowPet) {
                    //반려동물 이름을 바꿨을 경우
                    self.viewModel.duplicateTest()
                }
                
                guard let gender = self.viewModel.gender.value,
                      let birth = self.viewModel.birth.value,
                      let firstMeet = self.viewModel.firstMeet.value,
                      let weight = self.viewModel.weight.value
                else { return }
                
                self.makeAlert(alertTitle: "반려동물 수정", alertMessage: "입력하신 내용으로 수정할까요?", actionMessage: "수정") {
                    PetRepository().editItem(id: pet.id, name: self.viewModel.name.value, gender: gender, birth: birth, meet: firstMeet, weight: weight)
                    
                    print("삭제 시 파일 이름 \(pet.name)")
                    self.removeImageToDocument(filename: "\(self.viewModel.petID.value)")
                    
                    if let image = self.mainView.profileButton.currentImage {
                        print("저장 시 파일 이름 \(self.viewModel.petID.value)")
                        self.saveImageToDocument(image: image, filename: "\(self.viewModel.petID.value)")
                    }
                    
                    UserDefaultManager.shared.nowPet = self.viewModel.name.value
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.registerButtonClicked.bind { _ in
            self.viewModel.repository.printLink()

            self.viewModel.compareDate()
            
            if self.viewModel.checkDate.value { //생일보다 처음 만난 날이 먼저일 경우
                self.makeToast("처음 만난 날보다 생일이 이른 날짜여야합니다")
                self.viewModel.checkInputData.value = false
                
                return
            }

            self.viewModel.duplicateTest()

            if self.viewModel.checkInputData.value {
                
                self.makeAlert(alertTitle: "반려동물 등록", alertMessage: "입력하신 내용으로 등록할까요?", actionMessage: "저장") {
                    self.viewModel.appendNewPet()
                    
                    sleep(1)
                    
                    UserDefaultManager.shared.nowPet = self.viewModel.name.value
                    
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let nav = UINavigationController(rootViewController: PetDiaryTabBarController())

                    sceneDelegate?.window?.rootViewController = nav
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            }
        }
        
        if type == .new {
            //프로필 등록할 때 id값으로 새롭게 생성됨
            viewModel.petID.bind { value in
                if let image = self.mainView.profileButton.currentImage {
                    print("저장 시 파일 이름: \(self.viewModel.petID.value)")
                    self.saveImageToDocument(image: image, filename: "\(value)")
                }
            }
        }
    }
    
    private func registerAction() {
        viewModel.cameraButtonClicked.registerAction { _ in
            let vc = CameraBottomSheetViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.selectImage = { image in
                if let image = image {
                    self.mainView.profileButton.setImage(image, for: .normal)
                }
            }
            self.present(vc, animated: false)
        }
        
        viewModel.genderButtonClicked.registerAction { _ in
            let vc = GenderBottomSheetViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.viewModel.gender.value = self.viewModel.gender.value
            vc.selectGender = { gender in
                self.viewModel.gender.value = gender
            }
            self.present(vc, animated: false)
        }
        
        viewModel.dateButtonClicked.registerAction { dateType in
            let vc = DateBottomSheetViewController()
            vc.modalPresentationStyle = .overFullScreen
            guard let dateType = dateType else { return }
            vc.dateType = dateType
            vc.selectDate = { date in
                guard let date = date else { return }
                if dateType == .birth {
                    self.viewModel.birth.value = date
                } else {
                    self.viewModel.firstMeet.value = date
                }
            }
            self.present(vc, animated: false)
        }
    }
    
    private func addAction() {
        
        mainView.cameraButton.addAction(UIAction(handler: { action in
            self.viewModel.cameraButtonClicked.value = ()
        }), for: .touchUpInside)
        
        if type == .new {
            mainView.registerButton.addAction(UIAction(handler: { action in
                self.viewModel.registerButtonClicked.value = ()
            }), for: .touchUpInside)
        } else {
            mainView.registerButton.setTitle("수정하기", for: .normal)
            mainView.registerButton.addAction(UIAction(handler: { action in
                self.viewModel.editButtonClicked.value = ()
            }), for: .touchUpInside)
        }
        
        mainView.genderButton.addAction(UIAction(handler: { action in
            self.viewModel.genderButtonClicked.value = ()
        }), for: .touchUpInside)
        
        mainView.birthButton.addAction(UIAction(handler: { action in
            self.viewModel.dateButtonClicked.value = .birth
        }), for: .touchUpInside)
        
        mainView.meetButton.addAction(UIAction(handler: { action in
            self.viewModel.dateButtonClicked.value = .firstMeet
        }), for: .touchUpInside)

        mainView.nameTextField.addDoneButton(doneAction: #selector(inputName))
        
        mainView.weightTextField.addDoneButton(doneAction: #selector(inputWeight))
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

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}
