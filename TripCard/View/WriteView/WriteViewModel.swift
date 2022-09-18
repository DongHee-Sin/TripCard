//
//  WriteViewModel.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit
import RealmSwift


enum WriteViewStatus {
    case needEnterLocationData
    case needEnterPeriodData
    case dataCanBeStored
}


struct CardByDate {
    var photoImage: UIImage?
    var content: String?
}


class WriteViewModel {
    
    // MARK: - Propertys
    let repository = TripDataRepository.shared

    var mainPhotoImage: Observable<UIImage> = Observable(UIImage())
    var segmentValue: Observable<Int> = Observable(0)
    var location: Observable<String> = Observable("")
    var tripPeriod: Observable<(start: Date, end: Date)?> = Observable(nil)

    var cardByDate: Observable<[CardByDate]> = Observable([])
    
    
    var periodString: String {
        guard let tripPeriod = tripPeriod.value else {
            return ""
        }
        
        if tripPeriod.start == tripPeriod.end {
            return tripPeriod.start.string
        }else {
            return tripPeriod.start.string + " ~ " + tripPeriod.end.string
        }
    }
    
    
    var numberOfCell: Int {
        guard let tripPeriod = tripPeriod.value else {
            return 0
        }
        
        return Date.calcDateDifference(startDate: tripPeriod.start, endDate: tripPeriod.end)
    }
    
    
    var writeViewStatus: WriteViewStatus {
        guard !location.value.trimmingCharacters(in: .whitespaces).isEmpty else { return .needEnterLocationData }
        guard tripPeriod.value != nil else { return .needEnterPeriodData }
        
        return .dataCanBeStored
    }
    
    
    
    
    // MARK: - Methods
    func createTripCard() throws {
        let isDomestic = segmentValue.value == 0
        
        let imageByDate = cardByDate.value.map { $0.photoImage }
        
        let arr = cardByDate.value.map { $0.content }
        let contentByDate: List<String?> = List<String?>()
        arr.forEach {
            contentByDate.append($0)
        }
        
        guard let period = tripPeriod.value else {
            // 기간이 입력되지 않았다는 얼럿 띄워야 함.
            return
        }
        
        let trip = Trip(mainPhotoImage: "mainImage", isDomestic: isDomestic, location: location.value, tripPeriod: period, contentByDate: contentByDate)
        
        try repository.create(trip, mainImage: mainPhotoImage.value, imageByDate: imageByDate)
    }
}
