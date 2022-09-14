//
//  Date+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import Foundation


extension Date {
    
    static func calcDateDifference (startDate: Date, endDate: Date) -> Int {
        let second = startDate.timeIntervalSinceReferenceDate - endDate.timeIntervalSinceReferenceDate
        let day = Int(second / 86400)
        return day
    }
    
}

