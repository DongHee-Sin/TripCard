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
    
    
    var backupFileTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    
    static func calcDateDifference (startDate: Date, endDate: Date) -> Int {
        let second = endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        let day = Int(second / 86400)
        return day + 1
    }
    
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    
    private func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
}

