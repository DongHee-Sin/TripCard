//
//  DateCollectionViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


class DateCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .small)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(dateLabel)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    
    override func setConstraint() {
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func updateCell(day: Int) {
        dateLabel.text = "\(day)일차"
    }
}
