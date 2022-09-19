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
        
        let themeColorString = UserDefaultManager.shared.themeColor
        let themeColor = ThemeColor(rawValue: themeColorString) ?? .light
        
        switch themeColor {
        case .modern:
            backgroundColor = UIColor(hex: "EEE3CBff") ?? .white
            selectedColor = UIColor(hex: "D7C0AEff") ?? .label
            buttonColor = UIColor(hex: "967E76ff") ?? .label
            textColor = .black
        case .skyBlue:
            backgroundColor = UIColor(hex: "EFFFFDff") ?? .white
            selectedColor = UIColor(hex: "85F4FFff") ?? .label
            buttonColor = UIColor(hex: "42C2FFff") ?? .label
            textColor = .black
        case .purple:
            backgroundColor = UIColor(hex: "EBC7E8ff") ?? .white
            selectedColor = UIColor(hex: "BFACE0ff") ?? .label
            buttonColor = UIColor(hex: "645CAAff") ?? .label
            textColor = .black
        case .light:
            backgroundColor = UIColor(hex: "F9F9F9ff") ?? .white
            selectedColor = UIColor(hex: "FAF4B7ff") ?? .label
            buttonColor = UIColor(hex: "ECC5FBff") ?? .label
            textColor = .black
        case .dark:
            backgroundColor = UIColor(hex: "2C3639ff") ?? .white
            selectedColor = UIColor(hex: "A27B5Cff") ?? .label
            buttonColor = UIColor(hex: "DCD7C9ff") ?? .label
            textColor = .white
        }
        
    }
    
    
    
    
    // MARK: - Propertys
    private(set) var backgroundColor: UIColor
    
    private(set) var textColor: UIColor
    
    private(set) var buttonColor: UIColor
    
    private(set) var selectedColor: UIColor
    
    
    
    
    // MARK: - Methods
    static func themeColorChanged() {
        Self.shared = ColorManager()
    }
}
