//
//  UIView+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit


extension UIView {
    
    func addShadow(color: UIColor, width: CGFloat, height: CGFloat, alpha: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowPath = nil
    }
    
}
