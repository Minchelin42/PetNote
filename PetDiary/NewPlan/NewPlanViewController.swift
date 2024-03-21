//
//  NewPlanViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit
import SnapKit
import RealmSwift
import Toast
import UserNotifications

enum PlanType {
    case new
    case edit
}

class NewPlanViewController: UIViewController {
    
    let notification = Notification().notification
    
    let pet = PetRepository().fetch().first?.name ?? ""
    
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
    
    var type = PlanType.new
    
    var id: ObjectId?
    var nowTitle = ""
    var nowMemo = ""
    var nowTime: Date?
    var isSwitchOn = false
    var registerDate: Date = Date()
    var firstDate: Date = Date()
    var lastDate: Date? = nil
    
    var dateArray: [Date] = []
    
    var save: Bool = false
    var saveComplete: ((PlanType, Bool, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        var nowDate = firstDate
        
        if let lastDate = self.lastDate {
            while nowDate <= lastDate {
                dateArray.append(nowDate)
                nowDate = Calendar.current.date(byAdding: .day, value: 1,to: nowDate)!
            }
        } else {
            dateArray.append(firstDate)
        }
        
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
        saveComplete?(self.type, self.save, self.dateArray[0])
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
        
        if type == .new {
            navigationItem.title = "할 일 추가"
        } else {
            navigationItem.title = "할 일 수정"
        }
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.darkGreen]
        UINavigationBar.appearance().tintColor = Color.darkGreen
        
        titleLabel.text = "할 일"
        titleTextField.text = nowTitle
        titleTextField.underlined(viewWidth: view.bounds.width - 40, viewHeight: 30, color: Color.darkGreen!)
        
        memoLabel.text = "메모"
        memoTextView.text = nowMemo
        memoTextView.textColor = .black
        memoTextView.backgroundColor = .clear
        memoTextView.font = .systemFont(ofSize: 14)
        memoTextView.tintColor = Color.darkGreen
        
        dateLabel.text = "날짜"
        if let lastDate = self.lastDate {
            dateButton.setTitle("\(self.firstDate.changeDateFormat()) ~ \(lastDate.changeDateFormat())", for: .normal)
        } else {
            dateButton.setTitle("\(firstDate.changeDateFormat())", for: .normal)
        }
        dateButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        
        alarmLabel.text = "알람 여부"
        
        alarmSwitch.onTintColor = Color.green
        alarmSwitch.setOn(isSwitchOn, animated: false)
        toggleSwitch(alarmSwitch)
        alarmSwitch.addTarget(self, action: #selector(toggleSwitch), for: UIControl.Event.valueChanged)
        
        alarmTimeLabel.text = "알람 설정"
        
        alarmTimeButton.setTitle(nowTime != nil ? nowTime?.changeDateToTime() : "시간 선택", for: .normal)
        alarmTimeButton.addTarget(self, action: #selector(alarmTimeButtonClicked), for: .touchUpInside)
    }
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.alarmTimeView.isHidden = false
        } else {
            self.alarmTimeView.isHidden = true
        }
    }
    
    @objc func alarmTimeButtonClicked() { //시간 선택
        let vc = DateBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.dateType = .plan
        vc.selectTime = { time in
            self.nowTime = time
            self.alarmTimeButton.setTitle("\(time.changeDateToTime())", for: .normal)
        }
        present(vc, animated: true)
    }
    
    @objc func dateButtonClicked() { //날짜 선택
        let vc = CalendarBottomSheetViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.selectDate = { date in
            if !date.isEmpty {
                self.dateArray = date
                print(self.dateArray)
                if date.count > 1 {
                    if let lastDate = date.last {
                        self.dateButton.setTitle("\(date[0].changeDateFormat()) ~ \(lastDate.changeDateFormat())", for: .normal)
                    }
                } else {
                    self.dateButton.setTitle("\(date[0].changeDateFormat())", for: .normal)
                }
            }
        }
        present(vc, animated: true)
    }
    
    
    @objc func rightButtonItemClicked() {
        
        if titleTextField.text!.isEmpty {
            var style = ToastStyle()
            style.backgroundColor = Color.lightGreen!
            style.messageColor = .white
            style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
            self.view.makeToast("제목을 입력해주세요", duration: 2.0, position: .bottom, style: style)
            return
        }
        
        if alarmSwitch.isOn && nowTime == nil {
            var style = ToastStyle()
            style.backgroundColor = Color.lightGreen!
            style.messageColor = .white
            style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
            self.view.makeToast("알람 시간을 입력해주세요", duration: 2.0, position: .bottom, style: style)
            return
        }
        
        if type == .new {
            repository.printLink()
            if dateArray.count == 1 {
                let item = PlanTable(title: titleTextField.text ?? "", memo: memoTextView.text ?? "", date: self.dateArray[0], alarm: alarmSwitch.isOn, time: self.nowTime, registerDate: self.registerDate, firstDate: self.dateArray[0], lastDate: nil, pet: self.pet)
                repository.createItem(item)
                
                if alarmSwitch.isOn {
                    if let time = self.nowTime {
                        pushReservedNotification(title: "오늘의 할 일", body: "루비(이)와 산책하기", date: self.dateArray[0], time: time, identifier: "\(self.registerDate) + \(self.dateArray[0])")
                    }
                }
            } else {
                for index in 0..<dateArray.count {
                    let item = PlanTable(title: titleTextField.text ?? "", memo: memoTextView.text ?? "", date: self.dateArray[index], alarm: alarmSwitch.isOn, time: self.nowTime, registerDate: self.registerDate, firstDate: self.dateArray[0], lastDate: self.dateArray.last, pet: self.pet)
                    repository.createItem(item)
                    
                    if alarmSwitch.isOn {
                        if let time = self.nowTime {
                            pushReservedNotification(title: "테스트", body: "테스트입니다", date: self.dateArray[index], time: time, identifier: "\(self.registerDate) + \(self.dateArray[index])")
                        }
                    }
                }
            }
            
            self.save = true
        } else {
            
            let last: Date? = {
                if self.dateArray.count == 1 {
                    return nil
                } else {
                    return self.dateArray.last
                }
            }()
            
            let realm = try! Realm()
            try! realm.write {
                let predicate = NSPredicate(format: "registerDate == %@", self.registerDate as NSDate)
                
                let prePlan = repository.fetch().filter(predicate)
                print("prePlan 출력")
                print(prePlan)
                
                for index in 0..<prePlan.count {
                    notification.removePendingNotificationRequests(withIdentifiers: ["\(prePlan[index].registerDate) + \(prePlan[index].date)"])
                }
                
                realm.delete(prePlan)
            }
            

            
            if last == nil {
                repository.editItem(id: self.id, title: titleTextField.text ?? "", memo: memoTextView.text ?? "", date: self.dateArray[0], alarm: alarmSwitch.isOn, time: self.nowTime, firstDate: self.dateArray[0], lastDate: nil)
                
                if alarmSwitch.isOn {
                    if let time = self.nowTime {
                        pushReservedNotification(title: "테스트", body: "테스트입니다", date: self.dateArray[0], time: time, identifier: "\(self.registerDate) + \(self.dateArray[0])")
                    }
                }
            } else {
                
                for index in 0..<dateArray.count {
                    
                    let item = PlanTable(title: titleTextField.text ?? "", memo: memoTextView.text ?? "", date: self.dateArray[index], alarm: alarmSwitch.isOn, time: self.nowTime, registerDate: self.registerDate, firstDate: self.dateArray[0], lastDate: last, pet: self.pet)
                    repository.createItem(item)
                    
                    if alarmSwitch.isOn {
                        if let time = self.nowTime {
                            pushReservedNotification(title: "테스트", body: "테스트입니다", date: self.dateArray[index], time: time, identifier: "\(self.registerDate) + \(self.dateArray[index])")
                        }
                    }
                }
            }
            
            self.save = true
            
        }
        
        print("====등록 후====")
        notification.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.trigger)
            }
        })
        navigationController?.popViewController(animated: true)
    }
    
    @objc func leftButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func makeTriggerComponents(date: Date, time: Date) -> Date {
        // Calendar 및 DateComponents 생성

        var calendar = Calendar.current
        let componentsFromDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let componentsFromTime = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        
        var newComponents = DateComponents()
        newComponents.year = componentsFromDate.year
        newComponents.month = componentsFromDate.month
        newComponents.day = componentsFromDate.day
        newComponents.hour = componentsFromTime.hour
        newComponents.minute = componentsFromTime.minute
        
        // 새로운 날짜 생성
        if let newDate = calendar.date(from: newComponents) {
            return newDate
        } else {
            return Date()
        }
    }
    

    func pushReservedNotification(title: String, body: String, date: Date, time: Date, identifier: String) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        let target = makeTriggerComponents(date: date, time: time)
        
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: target)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        self.notification.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
