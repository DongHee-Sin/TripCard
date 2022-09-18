//
//  UICollectionViewLayout+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


extension UICollectionViewLayout {

    static func configureGridListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
            
        let sectionSpacing: CGFloat = 20
        let itemSpacing: CGFloat = 16
            
        let width: CGFloat = UIScreen.main.bounds.width - itemSpacing - (sectionSpacing * 2)
        let itemWidth: CGFloat = width / 2
        let itemHeight: CGFloat = (itemWidth * 1.25) + 55
            
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.minimumLineSpacing = itemSpacing * 2
        layout.minimumInteritemSpacing = itemSpacing
            
        return layout
    }
    
    
    static func configureCardLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
            
        let sectionSpacing: CGFloat = 44
            
        let width: CGFloat = UIScreen.main.bounds.width - (sectionSpacing * 2)
        let itemWidth: CGFloat = width
        let itemHeight: CGFloat = (itemWidth * 1.25) + 100
            
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
            
        return layout
    }
}
