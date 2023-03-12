//
//  DateFormatterManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/16.
//

import Foundation


final class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    private init() {}
    
    
    
    // MARK: - Propertys
    private let formatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    
    
    // MARK: - Methods
    func dateToString(date: Date) -> String {
        return formatter.string(from: date)
    }
}
