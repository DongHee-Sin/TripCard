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
    case green
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
            backgroundColor = UIColor(hex: "FFEDDBff")
            cellBackgroundColor = .white
            selectedColor = UIColor(hex: "E3B7A0ff")
            buttonColor = UIColor(hex: "967E76ff")
            textColor = .black
        case .skyBlue:
            backgroundColor = UIColor(hex: "EFFFFDff")
            cellBackgroundColor = UIColor(hex: "F6F5F5ff")
            selectedColor = UIColor(hex: "B8FFF9ff")
            buttonColor = UIColor(hex: "42C2FFff")
            textColor = .black
        case .purple:
            backgroundColor = UIColor(hex: "EBC7E8ff")
            cellBackgroundColor = UIColor(hex: "FDEBF7ff")
            selectedColor = UIColor(hex: "BFACE0ff")
            buttonColor = UIColor(hex: "645CAAff")
            textColor = .black
        case .green:
            backgroundColor = UIColor(hex: "DFE8CCff")
            cellBackgroundColor = UIColor(hex: "F7EDDBff")
            selectedColor = UIColor(hex: "B1D7B4ff")
            buttonColor = UIColor(hex: "7FB77Eff")
            textColor = .black
        case .light:
            backgroundColor = UIColor(hex: "F9F9F9ff")
            cellBackgroundColor = .white
            selectedColor = UIColor(hex: "FAF4B7ff")
            buttonColor = UIColor(hex: "ECC5FBff")
            textColor = .black
        case .dark:
            backgroundColor = UIColor(hex: "2C3639ff")
            cellBackgroundColor = .darkGray
            selectedColor = UIColor(hex: "395B64ff")
            buttonColor = UIColor(hex: "5C3D2Eff")
            textColor = .white
        }
    }
    
    
    private func setCustomThemeColor(_ customTheme: CustomThemeColor) {
        backgroundColor = dataToColor(data: customTheme.backgroundColor)
        cellBackgroundColor = dataToColor(data: customTheme.cellBackgroundColor)
        textColor = dataToColor(data: customTheme.textColor)
        buttonColor = dataToColor(data: customTheme.buttonColor)
        selectedColor = dataToColor(data: customTheme.selectedColor)
    }
    
    
    private func dataToColor(data: Data) -> UIColor? {
        return (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor) ?? UIColor()
    }
}
