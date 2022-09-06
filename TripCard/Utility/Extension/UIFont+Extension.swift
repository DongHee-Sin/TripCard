//
//  UIFont+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/07.
//

import UIKit


enum FontSize: CGFloat {
    case tabmanTitle = 17
    case normal = 15
    case userText = 13
}


extension UIFont {
    
    static func kyobo(size: FontSize) -> UIFont {
        return UIFont(name: "KyoboHandwriting2020", size: size.rawValue) ?? UIFont()
    }
    
    static func lefer(size: FontSize) -> UIFont {
        return UIFont(name: "LeferiBaseType-Regular", size: size.rawValue) ?? UIFont()
    }
    
    static func gangwon(size: FontSize) -> UIFont {
        return UIFont(name: "GangwonEduAll-OTFLight", size: size.rawValue) ?? UIFont()
    }
}
