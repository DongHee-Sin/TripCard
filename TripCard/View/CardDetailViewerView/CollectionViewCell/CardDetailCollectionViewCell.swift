//
//  CardDetailCollectionViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


class CardDetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .large)
    }
    
    let photoImage = UIImageView().then {
        $0.backgroundColor = ColorManager.shared.selectedColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.contentMode = .scaleToFill
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = ColorManager.shared.textColor
        $0.font = .systemFont(ofSize: FontSize.normal.rawValue)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [dateLabel, photoImage, contentLabel].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    
    override func setConstraint() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(photoImage.snp.width).multipliedBy(1.25)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    
    func updateCell(day: Int, content: String?, image: UIImage?) {
        dateLabel.text = "\(day)일차"
        photoImage.image = image
        contentLabel.text = content
    }
}
