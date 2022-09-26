//
//  ColorManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit


enum ThemeColor: String, CaseIterable {
    case modern
    case skyBlue
    case purple
    case light
    case dark
}


final class ColorManager {
    
    static private(set) var shared = ColorManager()
    
    
    
    
    // MARK: - Init
    private init() {
        setThemeColor()
    }
    
    
    
    
    // MARK: - Propertys
    private(set) var backgroundColor: UIColor?
    
    private(set) var cellBackgroundColor: UIColor?
    
    private(set) var textColor: UIColor?
    
    private(set) var unSelectedTextColor: UIColor?
    
    private(set) var buttonColor: UIColor?
    
    private(set) var selectedColor: UIColor?
    
    
    
    
    // MARK: - Methods
    static func themeColorChanged() {
        Self.shared.setThemeColor()
    }
    
    
    private func setThemeColor() {
        let themeColorString = UserDefaultManager.shared.themeColor
        let themeColor = ThemeColor(rawValue: themeColorString) ?? .light
        
        switch themeColor {
        case .modern:
            backgroundColor = UIColor(hex: "EEE3CBff")
            selectedColor = UIColor(hex: "D7C0AEff")
            buttonColor = UIColor(hex: "967E76ff")
            textColor = .black
        case .skyBlue:
            backgroundColor = UIColor(hex: "EFFFFDff")
            selectedColor = UIColor(hex: "85F4FFff")
            buttonColor = UIColor(hex: "42C2FFff")
            textColor = .black
        case .purple:
            backgroundColor = UIColor(hex: "EBC7E8ff")
            selectedColor = UIColor(hex: "BFACE0ff")
            buttonColor = UIColor(hex: "645CAAff")
            textColor = .black
        case .light:
            backgroundColor = UIColor(hex: "F9F9F9ff")
            selectedColor = UIColor(hex: "FAF4B7ff")
            buttonColor = UIColor(hex: "ECC5FBff")
            textColor = .black
        case .dark:
            backgroundColor = UIColor(hex: "2C3639ff")
            selectedColor = UIColor(hex: "A27B5Cff")
            buttonColor = UIColor(hex: "DCD7C9ff")
            textColor = .white
        }
    }
}
