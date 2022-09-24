//
//  CardViewerView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/18.
//

import UIKit
import FSPagerView


final class CardViewerView: BaseView {
    
    // MARK: - Propertys
    private let itenWidth: CGFloat = UIScreen.main.bounds.width - 88
    
    lazy var pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
        $0.itemSize = CGSize(width: itenWidth, height: itenWidth * 1.25 + 100)
        $0.isInfinite = true
        $0.register(CardViewerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(pagerView)
    }
    
    
    override func setConstraint() {
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
