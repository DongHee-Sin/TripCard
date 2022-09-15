//
//  UICollectionViewLayout+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


extension UICollectionViewLayout {
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)


            // Groub
            let groubSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))

            let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 2)


            // Section
            let section = NSCollectionLayoutSection(group: groub)

            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

            section.interGroupSpacing = 20


            return section
        }

        return layout
    }
    
    
//    static func configureCollectionViewLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewFlowLayout()
//
//        let itemSpacing: CGFloat = 16
//
//        let width: CGFloat = UIScreen.main.bounds.width - (itemSpacing * 3)
//        let itemWidth: CGFloat = width / 2
//
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
//        layout.minimumLineSpacing = itemSpacing + 8
//        layout.minimumInteritemSpacing = itemSpacing
//
//        return layout
//    }
}
