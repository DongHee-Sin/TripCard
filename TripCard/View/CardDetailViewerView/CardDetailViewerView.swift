//
//  CardDetailViewrView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit
import FSPagerView


final class CardDetailViewerView: BaseView {
    
    // MARK: - Propertys
    let dateCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .configureDateListLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    lazy var pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .overlap)
        $0.register(CardViewerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [dateCollectionView, pagerView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        dateCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(70)
        }
        
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(dateCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
