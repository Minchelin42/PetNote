//
//  CameraBottomSheetViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/10.
//

import UIKit
import SnapKit

class CameraBottomSheetViewController: UIViewController {

    let defaultHeight: CGFloat = 140
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkGray?.withAlphaComponent(0.7)
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background
        
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    let cameraButton = ProfileInputButton()
    let albumButton = ProfileInputButton()
    
    var userImage: UIImage? = nil

    var selectImage: ((UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(userImage)
        selectImage?(userImage)
    }
    
    @objc func dimmedViewTapped() {
        bottomSheetDisappear()
    }

    private func bottomSheetDisappear() {
        self.dimmedView.alpha = 0.0
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        showBottomSheet()
    }
    
    private func configureHierarchy() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubview(cameraButton)
        bottomSheetView.addSubview(albumButton)
        
        dimmedView.alpha = 0.0
    }
    
    private func configureLayout() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalToSuperview().inset(50)
        }
        
        albumButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func configureView() {
        
        cameraButton.setTitle("카메라로 촬영하기", for: .normal)
        albumButton.setTitle("앨범에서 선택하기", for: .normal)

        cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(albumButtonClicked), for: .touchUpInside)
    }
    
    @objc func albumButtonClicked() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func cameraButtonClicked() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func clearButtonClicked() {
        bottomSheetDisappear()
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo((safeAreaHeight + bottomPadding) - defaultHeight)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }
    }
}

extension CameraBottomSheetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("이미지 추가됨")
            self.userImage = pickedImage
        }
        
        dismiss(animated: true)
        bottomSheetDisappear()
    }
}

