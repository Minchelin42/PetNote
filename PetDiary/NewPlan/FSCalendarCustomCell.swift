//
//  FSCalendarCustomCell.swift
//  PetDiary
//
//  Created by 민지은 on 2024/03/15.
//

import FSCalendar

class FSCalendarCustomCell: FSCalendarCell {
    
    var circleBackImageView = UIImageView()
    var leftRectBackImageView = UIImageView()
    var rightRectBackImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
        settingImageView()
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        circleBackImageView.image = nil
        leftRectBackImageView.image = nil
        rightRectBackImageView.image = nil
    }
    
    func setConfigure() {
        
        contentView.insertSubview(circleBackImageView, at: 0)
        contentView.insertSubview(leftRectBackImageView, at: 0)
        contentView.insertSubview(rightRectBackImageView, at: 0)
    }
    
    func setConstraints() {
        
        // 날짜 텍스트의 레이아웃을 센터로 잡아준다 (기본적으로 약간 위에 있다)
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
        
        leftRectBackImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView.snp.centerX)
            make.height.equalTo(36)
            make.centerY.equalTo(contentView)
        }
        
        circleBackImageView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.size.equalTo(36)
        }
        
        rightRectBackImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX)
            make.trailing.equalTo(contentView)
            make.height.equalTo(36)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    func settingImageView() {
        circleBackImageView.clipsToBounds = true
        circleBackImageView.layer.cornerRadius = 18
        
        // 선택 날짜의 배경 색상을 여기서 정한다.
        [circleBackImageView, leftRectBackImageView, rightRectBackImageView].forEach { item  in
            item.backgroundColor = Color.moreLightGreen
        }
    }
    
    func updateBackImage(_ dateType: SelectedDateType) {
        
        switch dateType {
        case .singleDate:
            // left right hidden true
            // circle hidden false
            leftRectBackImageView.isHidden = true
            rightRectBackImageView.isHidden = true
            circleBackImageView.isHidden = false
            
        case .firstDate:
            // leftRect hidden true
            // circle, right hidden false
            leftRectBackImageView.isHidden = true
            circleBackImageView.isHidden = false
            rightRectBackImageView.isHidden = false
            
        case .middleDate:
            // circle hidden true
            // left, right hidden false
            circleBackImageView.isHidden = true
            leftRectBackImageView.isHidden = false
            rightRectBackImageView.isHidden = false
            
        case .lastDate:
            // rightRect hidden true
            // circle, left hidden false
            rightRectBackImageView.isHidden = true
            circleBackImageView.isHidden = false
            leftRectBackImageView.isHidden = false
            
        case .notSelectd:
            // all hidden
            circleBackImageView.isHidden = true
            leftRectBackImageView.isHidden = true
            rightRectBackImageView.isHidden = true
        }
        
    }
    
}
