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
        $0.clipsToBounds = true
        $0.image = UIImage(named: "TestImage")
    }
    
    let locationLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
    }
    
    let periodLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
        $0.minimumScaleFactor = 0.7
        $0.numberOfLines = 1
    }
    
    let locationImage = UIImageView().then {
        $0.image = UIImage.locationImage
        $0.tintColor = ColorManager.shared.textColor
    }
    
    let calendarImage = UIImageView().then {
        $0.image = UIImage.calendarImage
        $0.tintColor = ColorManager.shared.textColor
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .systemFont(ofSize: FontSize.userText.rawValue)
        $0.numberOfLines = 0
    }
    
    lazy var locationStackView = UIStackView().then { view in
        [locationImage, locationLabel].forEach {
            view.addSubview($0)
        }
        view.spacing = 8
        view.axis = .horizontal
    }
    
    lazy var periodStackView = UIStackView().then { view in
        [calendarImage, periodLabel].forEach {
            view.addSubview($0)
        }
        view.spacing = 8
        view.axis = .horizontal
    }
    
    lazy var cardStackView = UIStackView().then { view in
        [photoImage, locationStackView, periodStackView, contentLabel].forEach {
            view.addSubview($0)
        }
        view.spacing = 8
        view.axis = .vertical
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(cardStackView)
    }
    
    
    override func setConstraint() {
        cardStackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(0)
        }
        
        locationImage.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        calendarImage.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        photoImage.snp.makeConstraints { make in
            make.height.equalTo(photoImage.snp.width).multipliedBy(1.3)
        }
    }
}
