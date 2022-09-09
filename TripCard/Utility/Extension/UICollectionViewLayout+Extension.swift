//
//  UICollectionViewLayout+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


extension UICollectionViewLayout {
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemSpacing: CGFloat = 12
        
        let width: CGFloat = UIScreen.main.bounds.width - (itemSpacing * 3)
        let itemWidth: CGFloat = width / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        layout.minimumLineSpacing = itemSpacing + 8
        layout.minimumInteritemSpacing = itemSpacing
        
        return layout
    }
    
}
