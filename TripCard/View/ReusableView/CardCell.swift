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
    
    let contentLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .systemFont(ofSize: FontSize.small.rawValue)
        $0.numberOfLines = 0
    }
    
    lazy var locationStackView = UIStackView().then { view in
        [locationImage, locationLabel].forEach {
            view.addArrangedSubview($0)
        }
        view.spacing = 8
        view.axis = .horizontal
        
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
    }
    
    lazy var periodStackView = UIStackView().then { view in
        [calendarImage, periodLabel].forEach {
            view.addArrangedSubview($0)
        }
        view.spacing = 8
        view.axis = .horizontal
        
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: 8, right: 8)
    }
    
    lazy var cardStackView = UIStackView().then { view in
        [photoImage, locationStackView, periodStackView, contentLabel].forEach {
            view.addArrangedSubview($0)
        }
        view.spacing = 8
        view.axis = .vertical
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(cardStackView)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    
    override func setConstraint() {
        cardStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
        
        locationImage.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        calendarImage.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
}
