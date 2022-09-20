//
//  CardDetailViewrView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class CardDetailViewerView: BaseView {
    
    // MARK: - Propertys
    let dateCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .configureDateListLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    let cardCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .configureDetailCardLayout()).then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [dateCollectionView, cardCollectionView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        cardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
