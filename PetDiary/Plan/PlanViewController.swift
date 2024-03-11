//
//  PlanViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/11.
//

import UIKit
import FSCalendar
import SnapKit

class PlanViewController: UIViewController {
    
    let mainView = PlanView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background
 
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "Plan")

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return Color.darkGreen
    }
    
}

extension PlanViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plan", for: indexPath) as! PlanCollectionViewCell
        return cell
    }
    
    
}


#Preview {
    PlanViewController()
}
