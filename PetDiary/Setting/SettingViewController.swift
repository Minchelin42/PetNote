//
//  SettingViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/21.
//

import UIKit
import SnapKit

enum Setting {
    static let data = ["초기화"]
    static let appInfo = ["버전 정보"]
}

class SettingViewController: UIViewController {
    
    let profile = ProfileInfoView()
    let pet = {
         let targetPet = PetRepository().fetch().where {
             $0.name.equals(UserDefaultManager.shared.nowPet)
         }
        return targetPet[0]
    }()
    let settingView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("로드 시 파일 이름 : \(pet.id)")
        
        profile.profileButton.setImage(loadImageToDocument(filename: String(describing: pet.id)), for: .normal)
        profile.nameLabel.text = "\(pet.name)"
        profile.birthLabel.text = "🎂 \(pet.birth.changeDateFormat())"
    }
    
    func configureHierarchy() {
        view.addSubview(profile)
        view.addSubview(settingView)
    }
    
    func configureLayout() {
        profile.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(102)
        }
        
        settingView.snp.makeConstraints { make in
            make.top.equalTo(profile.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        
        navigationItem.title = "설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.darkGreen]
        UINavigationBar.appearance().tintColor = Color.darkGreen
        
        profile.clipsToBounds = true
        profile.layer.cornerRadius = 20
        profile.layer.masksToBounds = false
        profile.layer.shadowColor = Color.darkGray?.cgColor
        profile.layer.shadowOffset = CGSize(width: 0, height: 5)
        profile.layer.shadowOpacity = 0.3
        profile.layer.shadowRadius = 3.0

        profile.profileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        profile.editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        profile.profileButton.contentVerticalAlignment = .fill
        profile.profileButton.contentHorizontalAlignment = .fill
        
        settingView.delegate = self
        settingView.dataSource = self
        settingView.backgroundColor = .clear
        settingView.separatorStyle = .none
        settingView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingView.register(VersionTableViewCell.self, forCellReuseIdentifier: "version")
    }
    
    @objc func editProfile() {
        let vc = ProfileViewController()
        vc.type = .edit
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Setting.data.count
        } else {
            return Setting.appInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "version", for: indexPath) as! VersionTableViewCell
        
        var item: [String] = []
        
        if indexPath.section == 0 {
            item = Setting.data
        } else {
            item = Setting.appInfo
        }

        cell.title.text = item[indexPath.row]
        
        if item[indexPath.row] == "버전 정보" {
            cell.version.text = "1.0.0"
        }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && Setting.data[indexPath.row] == "초기화" {
            let alert = UIAlertController(title: "정말 데이터를 초기화할까요?", message: "삭제된 데이터는 다시 복구할 수 없습니다", preferredStyle: .alert)
            
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton = UIAlertAction(title: "초기화", style: .destructive) { action in
                
                let petList = PetRepository().fetch()
                
                for index in 0..<petList.count {
                    self.removeImageToDocument(filename: petList[index].name)
                }

                PlaceRepository().deleteAllItem()
                PlanRepository().deleteAllItem()
                PetRepository().deleteAllItem()
                UserDefaultManager.shared.nowPet = ""
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let nav = UINavigationController(rootViewController: OnboardingViewController())

                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }

            alert.addAction(cancelButton)
            alert.addAction(deleteButton)

            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "데이터"
        } else {
            return "앱 정보"
        }
    }
    
    
}
