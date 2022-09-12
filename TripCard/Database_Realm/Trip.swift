//
//  Trip.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import Foundation
import RealmSwift


final class Trip: Object {
    @Persisted var isDomestic: Bool
    @Persisted var location: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var numberOfDays: Int
    @Persisted var userInput: String         // 변수명 변경하기
    @Persisted var photoImages: List<String>

    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(isDomestic: Bool, location: String, startDate: Date, endDate: Date, userInput: String, photoImages: List<String>) {
        self.init()
        self.isDomestic = isDomestic
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.userInput = userInput
        self.photoImages = photoImages
        
        numberOfDays = Date.calcDateDifference(startDate: startDate, endDate: endDate)
    }
}
