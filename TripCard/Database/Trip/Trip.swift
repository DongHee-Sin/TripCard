//
//  Trip.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import Foundation
import RealmSwift


enum TripType: Int {
    case domestic
    case overseas
}


typealias TripPeriod = (start: Date, end: Date)


final class Trip: Object, Codable {
    @Persisted var isDomestic: Bool
    @Persisted var location: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var numberOfDate: Int

    @Persisted var contentByDate: List<String?>

    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    convenience init(tripType: TripType, location: String, tripPeriod: TripPeriod, contentByDate: List<String?>) {
        self.init()
        
        self.isDomestic = tripType == .domestic
        self.location = location
        self.startDate = tripPeriod.start
        self.endDate = tripPeriod.end
        self.numberOfDate = Date.calcDateDifference(startDate: startDate, endDate: endDate)
        
        self.contentByDate = contentByDate
    }
    
    
    enum CodingKeys: String, CodingKey {
        case isDomestic
        case location
        case startDate
        case endDate
        case numberOfDate
        case contentByDate
        case objectId
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(isDomestic, forKey: .isDomestic)
        try container.encode(location, forKey: .location)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(numberOfDate, forKey: .numberOfDate)
        try container.encode(contentByDate, forKey: .contentByDate)
    }
}
