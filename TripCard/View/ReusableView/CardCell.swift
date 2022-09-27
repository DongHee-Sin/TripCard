//
//  CardView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit
import SnapKit
import Then


enum CollectionViewType {
    case list
    case card
}


final class CardCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    let photoImage = UIImageView().then {
        $0.backgroundColor = ColorManager.shared.selectedColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.contentMode = .scaleToFill
    }
    
    let locationLabel = UILabel().then {
        $0.textColor = .black
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
    }
    
    let periodLabel = UILabel().then {
        $0.textColor = .black
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
    }
    
    let locationImage = UIImageView().then {
        $0.image = UIImage.locationImage
        $0.tintColor = .black
    }
    
    let calendarImage = UIImageView().then {
        $0.image = UIImage.calendarImage
        $0.tintColor = .black
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
            make.height.equalTo(locationLabel.snp.height)
        }
    }
    
    
    func updateCell(trip: Trip, mainImage: UIImage?, type: CollectionViewType) {
        self.photoImage.image = mainImage
        self.locationLabel.text = trip.location
        
        if trip.startDate == trip.endDate {
            self.periodLabel.text = trip.startDate.string
        }else {
            self.periodLabel.text = trip.startDate.string + " ~ " + trip.endDate.string
        }
        
        switch type {
        case .list:
            locationLabel.font = .customFont(size: .small)
            periodLabel.font = .customFont(size: .small)
        case .card:
            locationLabel.font = .customFont(size: .large)
            periodLabel.font = .customFont(size: .large)
        }
    }
}
