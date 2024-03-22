//
//  OnboardingViewController.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/22.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    let image = UIImageView()
    let button = CompleteButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    func configureHierarchy() {
        view.addSubview(image)
        view.addSubview(button)
    }
    
    func configureLayout() {
        image.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(55)
        }
        
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
    }
    
    func configureView() {

        image.image = UIImage(named: "start")
        image.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        button.setTitle("시작하기", for: .normal)
    }
    
    @objc func startButtonClicked() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
