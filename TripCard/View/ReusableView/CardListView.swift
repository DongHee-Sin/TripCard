//
//  CardListView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


final class CardListView: BaseView {
    
    // MARK: - Propertys
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .configureGridListLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
    }
}

