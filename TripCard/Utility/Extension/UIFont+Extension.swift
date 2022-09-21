//
//  UIFont+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/07.
//

import UIKit


enum FontSize: CGFloat {
    case largest = 20
    case large = 17
    case normal = 15
    case small = 13
}


extension UIFont {
    
    static func customFont(size: FontSize) -> UIFont {
        let savedFont = UserDefaultManager.shared.customFont
        return UIFont(name: savedFont, size: size.rawValue) ?? .systemFont(ofSize: size.rawValue)
    }
    
    
    static func customFont(font: CustomFont, size: FontSize) -> UIFont {
        let selectedFont = font.rawValue
        return UIFont(name: selectedFont, size: size.rawValue) ?? .systemFont(ofSize: size.rawValue)
    }
    
}
