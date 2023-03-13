//
//  DateCollectionViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class DateCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .small)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(dateLabel)
        
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = ColorManager.shared.selectedColor
    }
    
    
    override func setConstraint() {
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func updateCell(day: Int) {
        dateLabel.text = "trip_day".localized(number: day)
    }
}
