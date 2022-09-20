//
//  UICollectionViewLayout+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


extension UICollectionViewLayout {

    // MARK: - Flow Layout
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
    
    
    
        
    // MARK: - Compositional Layout
    static func configureDetailCardLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: 40)

            let groubSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

            let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: groub)
            section.orthogonalScrollingBehavior = .paging

            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 30, trailing: 20)

            return section
        }

        return layout
    }
    
    
    static func configureDateListLayout() -> UICollectionViewLayout {
            
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
            item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 12, bottom: 12, trailing: 12)
               
            let groubSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .fractionalHeight(1))
                
            let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 1)
                
            let section = NSCollectionLayoutSection(group: groub)
            section.orthogonalScrollingBehavior = .continuous
                
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
                
            return section
        }
            
        return layout
    }
}
