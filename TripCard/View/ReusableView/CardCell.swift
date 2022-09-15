//
//  CardView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit
import SnapKit
import Then


final class CardCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    let photoImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        
        $0.image = UIImage(named: "TestImage")
    }
    
    let locationLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .small)
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
        
        $0.text = "제주도 서귀포"
    }
    
    let periodLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .small)
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
        
        $0.text = "20.05.01 ~ 20.05.10"
    }
    
    let locationImage = UIImageView().then {
        $0.image = UIImage.locationImage
        $0.tintColor = ColorManager.shared.textColor
    }
    
    let calendarImage = UIImageView().then {
        $0.image = UIImage.calendarImage
        $0.tintColor = ColorManager.shared.textColor
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [photoImage, locationImage, locationLabel, calendarImage, periodLabel].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    
    override func setConstraint() {
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(photoImage.snp.width).multipliedBy(1.25)
        }
        
        locationImage.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalTo(self.snp.leading).offset(8)
            make.width.height.equalTo(16)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(8)
            make.leading.equalTo(locationImage.snp.trailing).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-8)
        }

        calendarImage.snp.makeConstraints { make in
            make.centerY.equalTo(periodLabel)
            make.leading.equalTo(self.snp.leading).offset(8)
            make.width.height.equalTo(16)
        }

        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.leading.equalTo(calendarImage.snp.trailing).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-8)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
}
