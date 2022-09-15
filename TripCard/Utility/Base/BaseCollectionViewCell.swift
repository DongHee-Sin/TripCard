//
//  BaseCollectionViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraint()
        
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {}
    
    func setConstraint() {}
    
    final private func addShadow() {
        self.addShadow(color: .black, width: 5, height: 5, alpha: 0.3, radius: 5)
        self.layer.masksToBounds = false
    }
}
