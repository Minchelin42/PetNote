//
//  CalendarView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/11.
//

import UIKit
import FSCalendar
import SnapKit

class PlanView: BaseView {
    
    let calendar = FSCalendar(frame: .zero)
    var calendarHeightConstraint: Constraint?
    
    var labelView = UIView()
    
    let dayLabel = {
        let label = UILabel()
        label.textColor = Color.font
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let plusButton = {
       let button = UIButton()
        button.backgroundColor = Color.darkGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(calendar)
        addSubview(labelView)
        labelView.addSubview(dayLabel)
        labelView.addSubview(plusButton)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            self.calendarHeightConstraint = make.height.equalTo(400).constraint
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(32)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.height.equalTo(20)
            make.trailing.lessThanOrEqualTo(plusButton.snp.leading).offset(-10)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20)
            make.size.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        setCalendar()
        dayLabel.text = "루비와 함께한 지 1,920일 째 일지"
        collectionView.backgroundColor = .clear

    }
    
    func setCalendar() {
        calendar.scope = .month
        
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = Color.darkGreen
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 18, weight: .semibold)
        
        calendar.appearance.weekdayTextColor = Color.darkGreen
        
        calendar.headerHeight = 60
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.titleWeekendColor = Color.darkGreen
        calendar.appearance.todayColor = Color.lightGreen
        calendar.appearance.eventDefaultColor = Color.green
        calendar.appearance.eventSelectionColor = Color.green
        
        calendar.backgroundColor = .white
        calendar.clipsToBounds = true
        calendar.layer.masksToBounds = false
        calendar.layer.shadowColor = Color.darkGray?.cgColor
        calendar.layer.shadowOffset = CGSize(width: 0, height: 5)
        calendar.layer.shadowOpacity = 0.5
        calendar.layer.shadowRadius = 3.0
        calendar.layer.cornerRadius = 30
        calendar.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMinXMaxYCorner]
    }
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.25)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
}

#Preview {
    PlanViewController()
}
