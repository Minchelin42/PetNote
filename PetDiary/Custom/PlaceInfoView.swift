//
//  PlaceInfoView.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/19.
//

import UIKit
import SnapKit

class PlaceInfoView: UIView {
    
    let titleLabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    let addressLabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 14, weight: .medium)
         label.textColor = Color.darkGray
         return label
     }()
    let infoLabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 14, weight: .medium)
         label.textColor = Color.darkGray
         label.numberOfLines = 0
         return label
     }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.background
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(infoLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

#Preview {
    PlaceInfoView()
}
