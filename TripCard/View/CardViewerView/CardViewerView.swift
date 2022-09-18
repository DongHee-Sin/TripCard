//
//  CardViewerView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/18.
//

import UIKit


final class CardViewerView: BaseView {
    
    // MARK: - Propertys
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .configureCardLayout()).then {
        $0.backgroundColor = .clear
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
