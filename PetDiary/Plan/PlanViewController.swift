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
import SwipeCellKit

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
        vc.firstDate = self.selectDate
        vc.saveComplete = { type, save in
            print(type)
            if save && type == .new {
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

extension PlanViewController: UICollectionViewDataSource, UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! PlanCollectionViewCell
        
        let item = list[indexPath.row]
        cell.delegate = self
        cell.titleLabel.text = item.title
        cell.memoLabel.text = item.memo
        cell.alarmLabel.text = item.alarm ? item.time?.changeDateToTime() : "알람 없음"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let edit = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            
            let vc = NewPlanViewController()
            vc.type = .edit
            
            vc.id = self.list[indexPath.row].id
            vc.nowTitle = self.list[indexPath.row].title
            vc.nowMemo = self.list[indexPath.row].memo
//            vc.selectDate = self.list[indexPath.row].date
            vc.isSwitchOn = self.list[indexPath.row].alarm
            vc.nowTime = self.list[indexPath.row].time
            vc.registerDate = self.list[indexPath.row].registerDate
            vc.firstDate = self.list[indexPath.row].firstDate
            vc.lastDate = self.list[indexPath.row].lastDate
            
            vc.saveComplete = { type, save in
                if save && type == .edit {
                    var style = ToastStyle()
                    style.backgroundColor = Color.lightGreen!
                    style.messageColor = .white
                    style.messageFont = .systemFont(ofSize: 14, weight: .semibold)
                    self.view.makeToast("할 일이 수정되었습니다", duration: 2.0, position: .bottom, style: style)
                }
            }

            self.navigationController?.pushViewController(vc, animated: true)
            print("edit 클릭")
            
            return
        }
        
        let delete = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            
            print("delete 클릭")
            
            let realm = try! Realm()
            try! realm.write {
                let predicate = NSPredicate(format: "registerDate == %@", self.list[indexPath.row].registerDate as NSDate)

                let prePlan = realm.objects(PlanTable.self).filter(predicate)
                
                realm.delete(prePlan)
            }

            self.mainView.calendar.reloadData()
            self.mainView.collectionView.reloadData()
            
            return
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .medium, scale: .medium)
        let xlargeConfig = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .medium, scale: .medium)
        
        edit.image = UIImage(systemName: "pencil", withConfiguration: xlargeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(Color.lightGreen)
        edit.backgroundColor = .clear
        edit.textColor = .lightGreen
        edit.font = .systemFont(ofSize: 13, weight: .semibold)
   
        edit.transitionDelegate = ScaleTransition.default
        
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(Color.darkGreen)
        delete.backgroundColor = .clear
        delete.textColor = .darkGreen
        delete.font = .systemFont(ofSize: 13, weight: .semibold)
   
        delete.transitionDelegate = ScaleTransition.default

        return [edit, delete]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        let expansion = SwipeExpansionStyle(target: .percentage(1.0), additionalTriggers: [], elasticOverscroll: true, completionAnimation: .bounce)
        
        var options = SwipeOptions()
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.expansionStyle = .none
        options.backgroundColor = .clear
        options.transitionStyle = .drag
        return options
    }
    
}

extension UIImage {

    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}


#Preview {
    PlanViewController()
}
