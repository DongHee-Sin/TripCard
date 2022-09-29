//
//  String+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/07.
//

import UIKit


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
    
    
    func changeColorSpecificText(text: String) -> NSMutableAttributedString {
        
        let range = (self as NSString).range(of: text, options: .caseInsensitive)

        let mutableAttributedString = NSMutableAttributedString.init(string: self)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: range)

        return mutableAttributedString
    }
}
