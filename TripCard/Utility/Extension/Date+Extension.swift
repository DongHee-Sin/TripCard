//
//  Date+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import Foundation


extension Date {
    
    var string: String {
        return DateFormatterManager.shared.dateToString(date: self)
    }
    
    
    static func calcDateDifference (startDate: Date, endDate: Date) -> Int {
        let second = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        let day = Int(second / 86400)
        return day + 1
    }
    
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
}

