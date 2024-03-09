//
//  DateBottomSheetViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/09.
//

import UIKit
import SnapKit

class DateBottomSheetViewController: UIViewController {
    
    var defaultHeight: CGFloat = 300
    
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
    
    let clearButton = CompleteButton()
    
    let datePicker = UIDatePicker()

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
        
        bottomSheetView.addSubview(clearButton)
        bottomSheetView.addSubview(datePicker)
        
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
        
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(35)
            make.top.equalToSuperview().inset(30)
            make.bottom.equalTo(clearButton.snp.top).offset(-10)
        }
        
        clearButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    func configureView() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        
        clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
    }
    
    @objc func clearButtonClicked() {
        print(datePicker.date)
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


#Preview {
    DateBottomSheetViewController()
}
