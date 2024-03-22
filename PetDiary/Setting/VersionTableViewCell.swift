//
//  VersionTableViewCell.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/22.
//

import UIKit
import SnapKit

class VersionTableViewCell: UITableViewCell {
    
    let title = UILabel()
    let version = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Color.darkGreen?.withAlphaComponent(0.3)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(title)
        contentView.addSubview(version)
    }
    
    func configureLayout() {
        title.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(5)
            make.leading.equalTo(self).offset(20)
        }
        
        version.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(20)
        }
    }
    
    func configureView() {
        title.font = .systemFont(ofSize: 14)
        title.textColor = Color.darkGreen
        version.font = .systemFont(ofSize: 13)
        version.textColor = Color.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
