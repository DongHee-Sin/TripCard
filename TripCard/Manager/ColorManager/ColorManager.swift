//
//  ColorManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit


enum ColorCombination: String {
    case modern
    case skyBlue
    case purple
    case light
    case dark
}


final class ColorManager {
    
    static let shared = ColorManager()
    
    private init() {}
    
    
    
    // MARK: - Propertys
    var backgroundColor: UIColor = UIColor(hex: "645CAA") ?? .label
    
    var tintColor: UIColor = UIColor(hex: "645CAA") ?? .label
    
    var buttonColor: UIColor = UIColor(hex: "645CAA") ?? .label
    
    var selectedColor: UIColor = UIColor(hex: "645CAA") ?? .label
    
    
    
    // MARK: - Method
    func colorCombinationChanged() {
        
        let colorCombinationString = UserDefaultManager.shared.colorCombination
        let colorCombination = ColorCombination(rawValue: colorCombinationString) ?? .light
        
        switch colorCombination {
        case .modern: break
        case .skyBlue: break
        case .purple: break
        case .light: break
        case .dark: break
        }
    }
}
