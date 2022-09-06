//
//  UserDefaultManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}


final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    
    
    // MARK: - Propertys
    @UserDefault(key: "font", defaultValue: "defaultFont")
    var font: String
    
    
    @UserDefault(key: "isInitialLaunch", defaultValue: false)
    var isInitialLaunch: Bool
    
    
    @UserDefault(key: "colorCombination", defaultValue: "light")
    var colorCombination: String
    
    
    
    // MARK: - Method
    func resetAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
