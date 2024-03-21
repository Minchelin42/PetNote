//
//  PetDiaryTabBarController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/19.
//

import UIKit

class PetDiaryTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setTabBarBackgroundColor()

        let planVC = PlanViewController()
        let placeVC = PlaceViewController()
        let settingVC = SettingViewController()

        planVC.tabBarItem.image = UIImage.init(named: "tab_plan_inactive")?.withRenderingMode(.alwaysOriginal)
        placeVC.tabBarItem.image = UIImage.init(named: "tab_map_inactive")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.image = UIImage.init(named: "tab_setting_inactive")?.withRenderingMode(.alwaysOriginal)

        planVC.tabBarItem.selectedImage = UIImage.init(named: "tab_plan")?.withRenderingMode(.alwaysOriginal)
        placeVC.tabBarItem.selectedImage = UIImage.init(named: "tab_map")?.withRenderingMode(.alwaysOriginal)
        settingVC.tabBarItem.selectedImage = UIImage.init(named: "tab_setting")?.withRenderingMode(.alwaysOriginal)
        
        planVC.tabBarItem.title = "Record"
        placeVC.tabBarItem.title = "Map"
        settingVC.tabBarItem.title = "My Page"

        let navSetting = UINavigationController(rootViewController: settingVC)
        
        setViewControllers([planVC, placeVC, navSetting], animated: false)

    }
    
//    func setTabBarBackgroundColor() {
//        tabBar.backgroundColor = Color.darkGreen
//         tabBar.isTranslucent = false
//     }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
