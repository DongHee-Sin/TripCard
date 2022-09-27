//
//  WriteViewModel.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit
import RealmSwift


enum WriteCardMode {
    case create
    case modify
}


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
    var writeCardMode: WriteCardMode = .create
    
    var forModifyTrip: Trip? {
        didSet {
            guard let trip = forModifyTrip else { return }
            segmentValue.value = trip.isDomestic ? 0 : 1
            location.value = trip.location
            tripPeriod.value = (trip.startDate, trip.endDate)
        }
    }
    
    let repository = TripDataRepository.shared

    var mainPhotoImage: Observable<UIImage?> = Observable(nil)
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
    
    
    var isDataEntered: Bool {
        return mainPhotoImage.value != nil || !location.value.isEmpty || tripPeriod.value != nil
    }
    
    
    private var imageByDate: [UIImage?] {
        return cardByDate.value.map { $0.photoImage }
    }
    
    
    private var contentByDate: List<String?> {
        let contentArray = cardByDate.value.map { $0.content }
        let contentByDate: List<String?> = List<String?>()
        contentByDate.append(objectsIn: contentArray)
        
        return contentByDate
    }
    
    
    
    
    // MARK: - Methods
    func finishButtonTapped() throws {
        switch writeCardMode {
        case .create:
            try createTripCard()
        case .modify:
            try updateTripCard()
        }
    }
    
    
    private func createTripCard() throws {
        let tripType = TripType(rawValue: segmentValue.value) ?? .domestic
        
        guard let period = tripPeriod.value else { return }
        
        let trip = Trip(tripType: tripType, location: location.value, tripPeriod: period, contentByDate: contentByDate)

        try repository.create(trip, mainImage: mainPhotoImage.value, imageByDate: imageByDate)
    }
    
    
    private func updateTripCard() throws {
        guard let trip = forModifyTrip else { return }
        
        try repository.update(trip: trip, mainImage: mainPhotoImage.value, imageByDate: imageByDate) { trip in
            trip.isDomestic = segmentValue.value == 0
            trip.location = location.value
            trip.contentByDate = contentByDate
            
            if let tripPeriod = tripPeriod.value {
                trip.startDate = tripPeriod.start
                trip.endDate = tripPeriod.end
                trip.numberOfDate = Date.calcDateDifference(startDate: tripPeriod.start, endDate: tripPeriod.end)
            }
        }
    }
}
