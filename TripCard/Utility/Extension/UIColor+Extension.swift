//
//  UIColor+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit


extension UIColor {
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.count == 8 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }

        return nil
    }
    
    
}
