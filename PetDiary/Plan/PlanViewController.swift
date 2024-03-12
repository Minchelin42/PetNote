//
//  PlanViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/11.
//

import UIKit
import FSCalendar
import SnapKit
import RealmSwift
import Toast

class PlanViewController: UIViewController {
    
    let mainView = PlanView()
    
    var selectDate = Date()
    
    let repository = PlanRepository()
    var list: Results<PlanTable>!
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.list = repository.fetch()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.background
 
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "Plan")
        
        mainView.plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let start = Calendar.current.startOfDay(for: mainView.calendar.selectedDate ?? Date())
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()

        let predicate = NSPredicate(format: "date >= %@ && date < %@", start as NSDate, end as NSDate)
        
        self.list = repository.fetch().filter(predicate)
        self.mainView.collectionView.reloadData()
        self.mainView.calendar.reloadData()
    }

    @objc func plusButtonClicked() {
        let vc = NewPlanViewController()
        vc.selectDate = self.selectDate
        vc.saveComplete = { save in
            if save {
                var style = ToastStyle()
                style.backgroundColor = Color.lightGreen!
                style.messageColor = .white
                style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
                self.view.makeToast("새로운 할 일이 추가되었습니다", duration: 2.0, position: .bottom, style: style)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up {
            mainView.calendar.setScope(.week, animated: true)
        }
        else if swipe.direction == .down {
            mainView.calendar.setScope(.month, animated: true)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension PlanViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
   
        UIView.animate(withDuration: 0.5) {
            self.mainView.calendarHeightConstraint?.update(offset: bounds.height)

            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectDate = date
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return Color.darkGreen
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
       
        let start = Calendar.current.startOfDay(for: date)
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? date

        let predicate = NSPredicate(format: "date >= %@ && date < %@", start as NSDate, end as NSDate)
        
        let event = repository.fetch().filter(predicate)
        
        return event.count
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let start = Calendar.current.startOfDay(for: date)
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? date

        let predicate = NSPredicate(format: "date >= %@ && date < %@", start as NSDate, end as NSDate)
        
        self.list = repository.fetch().filter(predicate)
        self.mainView.collectionView.reloadData()
        return true
    }
    
}

extension PlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! PlanCollectionViewCell
        
        let item = list[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.memoLabel.text = item.memo
        cell.alarmLabel.text = item.alarm ? item.time?.changeDateToTime() : "알람 없음"
        
        return cell
    }
    
    
}


#Preview {
    PlanViewController()
}
