//
//  Trip.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import Foundation
import RealmSwift


typealias TripPeriod = (start: Date, end: Date)


final class Trip: Object {
    @Persisted var mainPhotoImage: String
    @Persisted var isDomestic: Bool
    @Persisted var location: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var numberOfDate: Int

    @Persisted var contentByDate: List<String?>

    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    convenience init(mainPhotoImage: String, isDomestic: Bool, location: String, tripPeriod: TripPeriod, contentByDate: List<String?>) {
        self.init()
        
        self.mainPhotoImage = mainPhotoImage
        self.isDomestic = isDomestic
        self.location = location
        self.startDate = tripPeriod.start
        self.endDate = tripPeriod.end
        self.numberOfDate = Date.calcDateDifference(startDate: startDate, endDate: endDate)
        
        self.contentByDate = contentByDate
    }
}
