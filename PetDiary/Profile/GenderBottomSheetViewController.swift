//
//  GenderBottomSheetViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit

class GenderBottomSheetViewController: UIViewController {

    var defaultHeight: CGFloat = 200
    
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
    
    let boyButton = ProfileInputButton()
    let girlButton = ProfileInputButton()
    
    let clearButton = CompleteButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    @objc func dimmedViewTapped() {
        bottomSheetDisappear()
    }
    
    @objc func genderSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.titleLabel?.text == "남아" {
            if girlButton.isSelected {
                girlButton.isSelected.toggle()
            }
        } else {
            if boyButton.isSelected {
                boyButton.isSelected.toggle()
            }
        }
        changeButtonStyle(boyButton)
        changeButtonStyle(girlButton)
        
    }
    
    func changeButtonStyle(_ button: UIButton) {
        if button.isSelected {
            button.setTitleColor(Color.font, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = Color.darkGreen?.cgColor
        } else {
            button.setTitleColor(Color.darkGray, for: .normal)
            button.layer.borderWidth = 0
        }
    }
    
    func bottomSheetDisappear() {
        self.dimmedView.alpha = 0.0
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        showBottomSheet()
    }
    
    func configureHierarchy() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubview(boyButton)
        bottomSheetView.addSubview(girlButton)
        bottomSheetView.addSubview(clearButton)
        
        dimmedView.alpha = 0.0
    }
    
    func configureLayout() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height)
        }
        
        boyButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalToSuperview().inset(50)
        }
        
        girlButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalTo(boyButton.snp.bottom).offset(8)
        }
        
        clearButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    func configureView() {
        
        boyButton.setTitle("남아", for: .normal)
        girlButton.setTitle("여아", for: .normal)
        boyButton.addTarget(self, action: #selector(genderSelected), for: .touchUpInside)
        girlButton.addTarget(self, action: #selector(genderSelected), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
    }
    
    @objc func clearButtonClicked() {
        bottomSheetDisappear()
    }
    
    func showBottomSheet() {
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
