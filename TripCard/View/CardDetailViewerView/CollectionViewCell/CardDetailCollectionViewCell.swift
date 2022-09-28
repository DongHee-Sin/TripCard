//
//  CardDetailCollectionViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


class CardDetailCollectionViewCell: MainPagerViewCell {
    
    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .customFont(size: .large)
    }
    
    let photoImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = ColorManager.shared.selectedColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let contentTextView = UITextView().then {
        $0.layer.cornerRadius = 20
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.textColor = .black
        $0.font = .customFont(size: .normal)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [dateLabel, photoImage, contentTextView].forEach {
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
            make.height.equalTo(40)
        }
        
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            
            var isNotch: Bool {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                return Double(window?.safeAreaInsets.bottom ?? -1) > 0
            }
            
            make.height.equalTo(photoImage.snp.width).multipliedBy(isNotch ? 1.25 : 1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    
    func updateCell(day: Int, content: String?, image: UIImage?) {
        dateLabel.text = "trip_day".localized(number: day)
        photoImage.image = image
        contentTextView.text = content
    }
}
