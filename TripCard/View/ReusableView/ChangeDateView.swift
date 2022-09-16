//
//  ChangeDateView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/16.
//

import UIKit


final class ChangeDateView: BaseView {
    
    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
    }
    
    let backButton = UIButton().then {
        $0.tintColor = ColorManager.shared.textColor
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    let nextButton = UIButton().then {
        $0.tintColor = ColorManager.shared.textColor
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    }
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [backButton, dateLabel, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        backButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(self.snp.leading)
            make.width.equalTo(backButton.snp.height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(self.snp.trailing)
            make.width.equalTo(backButton.snp.height)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing)
            make.trailing.equalTo(nextButton.snp.leading)
        }
    }
}
