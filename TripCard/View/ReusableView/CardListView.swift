//
//  CardListView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


final class CardListView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .configureCollectionViewLayout())
    
    
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(0)
        }
    }
}

