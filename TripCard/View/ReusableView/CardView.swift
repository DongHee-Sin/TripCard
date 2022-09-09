//
//  CardView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit
import SnapKit
import Then


final class CardView: BaseView {
    
    // MARK: - Propertys
    let photoImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    let locationLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        
    }
    
    
    
    // MARK: - Methods
    
}
