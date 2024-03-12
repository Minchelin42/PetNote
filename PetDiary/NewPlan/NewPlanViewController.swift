//
//  NewPlanViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit
import SnapKit

class NewPlanViewController: UIViewController {
    
    let repository = PlanRepository()
    
    let titleLabel = NewPlanLabel()
    let titleTextField = NewPlanTextField()
    
    let memoLabel = NewPlanLabel()
    let memoTextView = UITextView()
    let memoLine = GreenLine()
    
    let dateLabel = NewPlanLabel()
    let dateButton = {
       let button = UIButton()
        button.setTitleColor(Color.darkGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    let dateLine = GreenLine()
    
    let alarmLabel = NewPlanLabel()
    let alarmLine = GreenLine()
    let alarmSwitch = UISwitch()
    
    let alarmTimeView = UIView()
    let alarmTimeLabel = NewPlanLabel()
    let alarmTimeButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = Color.green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
       return button
    }()
    let alarmTimeLine = GreenLine()
    
    var nowTime: Date?
    
    var selectDate: Date = Date()
    
    var save: Bool = false
    var saveComplete: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveComplete?(self.save)
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(memoLabel)
        view.addSubview(memoTextView)
        view.addSubview(memoLine)
        view.addSubview(dateLabel)
        view.addSubview(dateButton)
        view.addSubview(dateLine)
        view.addSubview(alarmLabel)
        view.addSubview(alarmLine)
        view.addSubview(alarmSwitch)
        view.addSubview(alarmTimeView)
        alarmTimeView.addSubview(alarmTimeLabel)
        alarmTimeView.addSubview(alarmTimeButton)
        alarmTimeView.addSubview(alarmTimeLine)
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(50)
            make.leading.equalTo(18)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.width.equalTo(50)
            make.leading.equalTo(18)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(80)
        }
        
        memoLine.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1.5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateButton)
            make.width.equalTo(60)
            make.leading.equalTo(18)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(memoLine.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        dateLine.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1.5)
        }
        
        alarmLabel.snp.makeConstraints { make in
            make.centerY.equalTo(alarmSwitch)
            make.width.equalTo(60)
            make.leading.equalTo(18)
        }
        
        alarmSwitch.snp.makeConstraints { make in
            make.top.equalTo(dateLine.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        alarmLine.snp.makeConstraints { make in
            make.top.equalTo(alarmSwitch.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1.5)
        }
        
        alarmTimeView.snp.makeConstraints { make in
            make.top.equalTo(alarmLine.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }
        
        alarmTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(alarmTimeButton)
            make.width.equalTo(60)
            make.leading.equalTo(18)
        }
        
        alarmTimeButton.snp.makeConstraints { make in
            make.top.equalTo(alarmLine.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        alarmTimeLine.snp.makeConstraints { make in
            make.top.equalTo(alarmTimeButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1.5)
        }
        
    }
    
    func configureView() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftButtonItemClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonItemClicked))
        
        navigationItem.title = "할 일 추가"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.darkGreen]
        UINavigationBar.appearance().tintColor = Color.darkGreen
        
        titleLabel.text = "할 일"
        titleTextField.underlined(viewWidth: view.bounds.width - 40, viewHeight: 30, color: Color.darkGreen!)
        
        memoLabel.text = "메모"
        memoTextView.backgroundColor = .clear
        memoTextView.font = .systemFont(ofSize: 14)
        memoTextView.tintColor = Color.darkGreen
        
        dateLabel.text = "날짜"
        dateButton.setTitle("\(selectDate.changeDateFormat())", for: .normal)

        alarmLabel.text = "알람 여부"
        
        alarmSwitch.onTintColor = Color.green
        alarmSwitch.addTarget(self, action: #selector(toggleSwitch), for: UIControl.Event.valueChanged)

        alarmTimeView.isHidden = true
        
        alarmTimeLabel.text = "알람 설정"

        alarmTimeButton.setTitle("시간 선택", for: .normal)
        alarmTimeButton.addTarget(self, action: #selector(alarmTimeButtonClicked), for: .touchUpInside)
    }
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.alarmTimeView.isHidden = false
        } else {
            self.alarmTimeView.isHidden = true
        }
    }
    
    @objc func alarmTimeButtonClicked() {
        let vc = DateBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.dateType = .plan
        vc.selectTime = { time in
            self.nowTime = time
            self.alarmTimeButton.setTitle("\(time.changeDateToTime())", for: .normal)
        }
        present(vc, animated: true)
    }
    
    @objc func rightButtonItemClicked() {
        repository.printLink()
        let item = PlanTable(title: titleTextField.text ?? "", memo: memoTextView.text ?? "", date: self.selectDate, alarm: alarmSwitch.isOn, time: self.nowTime)
        repository.createItem(item)
        self.save = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc func leftButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
}




#Preview {
    NewPlanViewController()
}
