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
    lazy var pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
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
