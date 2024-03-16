//
//  CalendarBottomSheetViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/15.
//

import UIKit
import SnapKit
import FSCalendar

enum SelectedDateType {
    case singleDate    // 날짜 하나만 선택된 경우 (원 모양 배경)
    case firstDate    // 여러 날짜 선택 시 맨 처음 날짜
    case middleDate // 여러 날짜 선택 시 맨 처음, 마지막을 제외한 중간 날짜
    case lastDate   // 여러 날짜 선택시 맨 마지막 날짜
    case notSelectd // 선택되지 않은 날짜
}

class CalendarBottomSheetViewController: UIViewController {
    
    let defaultHeight: CGFloat = 450
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkGray?.withAlphaComponent(0.7)
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background
        
        view.layer.cornerRadius = 25
        return view
    }()
    
    let clearButton = CompleteButton()
    let calendar = FSCalendar(frame: .zero)
    
    var selectDate: (([Date]) -> Void)?
    
    private var firstDate: Date?    // 배열 중 첫번째 날짜
    private var lastDate: Date?        // 배열 중 마지막 날짜
    private var datesRange: [Date] = []    // 선택된 날짜 배열

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        calendar.dataSource = self
        calendar.delegate = self
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectDate?(datesRange)
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
        
        view.addSubview(calendar)
        view.addSubview(clearButton)
        
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
        
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(bottomSheetView).inset(30)
            make.top.equalTo(bottomSheetView).inset(40)
            make.height.equalTo(350)
        }
        
        clearButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.top.equalTo(calendar.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(bottomSheetView).inset(35)
        }
    }
    
    private func configureView() {

        setCalendar()
        clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
    }
    
    func setCalendar() {
        calendar.scope = .month
        
        //여러 개 선택 가능
        calendar.allowsMultipleSelection = true
        
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.description())  // 커스텀 셀 등록
        
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = Color.darkGreen
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 18, weight: .semibold)
        
        calendar.appearance.weekdayTextColor = Color.darkGreen
        
        calendar.headerHeight = 60
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.titleWeekendColor = Color.darkGreen
        
        calendar.today = nil    // 기본 오늘 선택 해제
        
        calendar.appearance.titleSelectionColor = Color.darkGreen
//        calendar.appearance.titleFont = .boldSystemFont(ofSize: 13)
        calendar.appearance.selectionColor = .clear

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

extension CalendarBottomSheetViewController: FSCalendarDataSource {
    
    // 매개변수로 들어온 date의 타입을 반환한다
    func typeOfDate(_ date: Date) -> SelectedDateType {
        
        let arr = datesRange
        
        if !arr.contains(date) {
            return .notSelectd    // 배열이 비어있으면 무조건 notSelected
        }
        
        else {
            // 배열의 count가 1이고, firstDate라면 singleDate
            if arr.count == 1 && date == firstDate { return .singleDate }
            
            // 배열의 count가 2 이상일 때, 각각 타입 반환
            if date == firstDate { return .firstDate }
            if date == lastDate { return .lastDate }
            
            else { return .middleDate }
        }
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.description(), for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }

        // 현재 그리는 셀의 date의 타입에 기반해서 셀 디자인
        cell.updateBackImage(typeOfDate(date))


        return cell
    }
}

extension CalendarBottomSheetViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // case 1. 현재 아무것도 선택되지 않은 경우
            // 선택 date -> firstDate 설정
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            calendar.reloadData() // (매번 reload)
            return
        }
        
        // case 2. 현재 firstDate 하나만 선택된 경우
        if firstDate != nil && lastDate == nil {
            // case 2 - 1. firstDate 이전 날짜 선택 -> firstDate 변경
            if date < firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                calendar.reloadData()    // (매번 reload)
                return
            }
            
            // case 2 - 2. firstDate 이후 날짜 선택 -> 범위 선택
            else {
                var range: [Date] = []
                
                var currentDate = firstDate!
                while currentDate <= date {
                    range.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                for day in range {
                    calendar.select(day)
                }
                
                lastDate = range.last
                datesRange = range
                
                calendar.reloadData()    // (매번 reload)
                return
            }
        }
        
        // case 3. 두 개가 모두 선택되어 있는 상태 -> 현재 선택된 날짜 모두 해제 후 선택 날짜를 firstDate로 설정
        if firstDate != nil && lastDate != nil {

            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            
            lastDate = nil
            firstDate = date
            calendar.select(date)
            datesRange = [firstDate!]
                
            calendar.reloadData()    // (매번 reload)
            return
        }
        
        
    }
    
    // 이미 선택된 날짜들 중 하나를 선택 -> 선택된 날짜 모두 초기화
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let arr = datesRange
        if !arr.isEmpty {
            for day in arr {
                calendar.deselect(day)
            }
        }
        firstDate = nil
        lastDate = nil
        datesRange = []
        
        calendar.reloadData()    // (매번 reload)
    }
}

#Preview {
    NewPlanViewController()
}

