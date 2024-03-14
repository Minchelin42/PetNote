//
//  PlanCollectionViewCell.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/12.
//

import UIKit
import SnapKit
import SwipeCellKit

class PlanCollectionViewCell: SwipeCollectionViewCell {
    
    let baseView = UIView()
    let memoView = UIView()
    
    let icon = UIImageView()
    
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let alarmLabel = UILabel()
    let clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(baseView)
        contentView.addSubview(memoView)
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(memoLabel)
        contentView.addSubview(alarmLabel)
        contentView.addSubview(clearButton)
        
    }
    
    func configureLayout() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        memoView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(baseView.snp.leading).inset(47)
        }
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(baseView.snp.leading).inset(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(memoView.snp.top).offset(14)
            make.leading.equalTo(memoView.snp.leading).inset(16)
            make.height.equalTo(18)
            make.trailing.lessThanOrEqualTo(clearButton.snp.leading).offset(-10)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(18)
            make.trailing.lessThanOrEqualTo(clearButton.snp.leading).offset(-10)
        }
        
        alarmLabel.snp.makeConstraints { make in
            make.bottom.equalTo(memoView.snp.bottom).inset(14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(18)
            make.trailing.lessThanOrEqualTo(clearButton.snp.leading).offset(-10)
        }
        
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(memoView.snp.trailing).offset(-15)
        }
  
    }
    
    func configureView() {
        baseView.backgroundColor = Color.darkGreen
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = 7
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = Color.lightGray?.cgColor
        
        baseView.layer.masksToBounds = false
        baseView.layer.shadowColor = Color.lightGray?.cgColor
        baseView.layer.shadowOffset = CGSize(width: 2, height: 5)
        baseView.layer.shadowOpacity = 1.0
        baseView.layer.shadowRadius = 3.0
        
        memoView.backgroundColor = .white
        memoView.clipsToBounds = true
        memoView.layer.cornerRadius = 7
        memoView.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMaxXMinYCorner]
        memoView.layer.borderWidth = 1
        memoView.layer.borderColor = Color.lightGray?.cgColor
        
        icon.image = UIImage(named: "paw")
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.text = "목욕하기"
        titleLabel.textColor = .black
        
        memoLabel.font = .systemFont(ofSize: 13, weight: .medium)
        memoLabel.textColor = Color.darkGray
        memoLabel.text = "귀에 물 안들어가게 하기"
        
        alarmLabel.font = .systemFont(ofSize: 13, weight: .medium)
        alarmLabel.textColor = Color.darkGray?.withAlphaComponent(0.6)
        alarmLabel.text = "알림 없음"
        
        clearButton.clipsToBounds = true
        clearButton.layer.cornerRadius = 10
        clearButton.layer.borderWidth = 1.2
        clearButton.layer.borderColor = Color.darkGreen?.cgColor
    }
    
    
}

#Preview {
    PlanViewController()
}


