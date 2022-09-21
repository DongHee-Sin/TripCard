//
//  TripDataRepository.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import Foundation
import RealmSwift
import UIKit


protocol TripDataRepositoryType {
    func create(_ trip: Trip, mainImage: UIImage?, imageByDate: [UIImage?]) throws
    
    func fetchTrip(at index: Int, tripType: TripType) -> Trip?
    
    func update(trip: Trip, mainImage: UIImage?, imageByDate: [UIImage?], completion: (Trip) -> Void) throws
    
    func remove(trip: Trip) throws
    
    func addObserver(to tripType: TripType, completion: @escaping () -> Void)
    
//    func fetchSearchResult(searchWord: String)
//    func getSearchResult(at index: Int) -> Trip?
}


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}


final class TripDataRepository: TripDataRepositoryType {
    
    // MARK: - Propertys
    static let shared = TripDataRepository()
    
    private let localRealm = try! Realm()
    
    let documentManager = DocumentManager()
    
    // Database Table
    private var totalTripList: Results<Trip>
    private var domesticList: Results<Trip>
    private var overseasList: Results<Trip>
    
    var domesticCount: Int { domesticList.count }
    var overseasCount: Int { overseasList.count }
    
    // Observer 토큰
    private var domesticTripNotificationToken: NotificationToken?
    private var overseasTripNotificationToken: NotificationToken?
    
    
    // SearchController
    private var searchResultList: Results<Trip>?
    var searchResultCount: Int { searchResultList?.count ?? 0 }
    
    
    
    
    // MARK: - Init
    private init() {
        self.totalTripList = localRealm.objects(Trip.self).sorted(byKeyPath: "startDate", ascending: false)
        
        self.domesticList = totalTripList.where {
            $0.isDomestic == true
        }
        
        self.overseasList = totalTripList.where {
            $0.isDomestic == false
        }
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    
    // MARK: - Methods
    // Create(add)
    func create(_ trip: Trip, mainImage: UIImage?, imageByDate: [UIImage?]) throws {
        do {
            try localRealm.write {
                localRealm.add(trip)
            }
        }
        catch {
            throw RealmError.writeError
        }
        
        try documentManager.saveImageToDocument(directoryName: trip.objectId.stringValue, mainImage: mainImage, imageByDate: imageByDate)
    }
    
    
    
    // Read
    func fetchTrip(at index: Int, tripType: TripType) -> Trip? {
        switch tripType {
        case .domestic:
            guard index < domesticCount else { return nil }
            return domesticList[index]
        case .overseas:
            guard index < overseasCount else { return nil }
            return overseasList[index]
        }
    }
    
    
    
    // Update
    func update(trip: Trip, mainImage: UIImage?, imageByDate: [UIImage?], completion: (Trip) -> Void) throws {
        let directoryName = trip.objectId.stringValue
        
        do {
            try localRealm.write({
                completion(trip)
            })
        }
        catch {
            throw RealmError.updateError
        }
        
        try documentManager.updateImage(directoryName: directoryName, mainImage: mainImage, imageByDate: imageByDate)
    }
    
    
    
    // Delete
    func remove(trip: Trip) throws {
        let directoryName = trip.objectId.stringValue
        
        do {
            try localRealm.write {
                localRealm.delete(trip)
            }
        }
        catch {
            throw RealmError.deleteError
        }
        
        try documentManager.removeImageDirectoryFromDocument(directoryName: directoryName)
    }
    
    
    
    // Observer 달기
    func addObserver(to tripType: TripType, completion: @escaping () -> Void) {
        switch tripType {
        case .domestic:
            domesticTripNotificationToken = domesticList.observe { _ in
                completion()
            }
        case .overseas:
            overseasTripNotificationToken = overseasList.observe { _ in
                completion()
            }
        }
    }
    
    
    
    func restoreData(urlString: String) throws {
        guard let data = urlString.data(using: .utf8) else {
            return
        }
        
        try localRealm.write {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
//            localRealm.add(json, update: .all)
        }
    }
    
    
    // SearchController
//    func fetchSearchResult(searchWord: String) {
//        searchResultList = totalTripList.where {
//            $0.title.contains(searchWord, options: .caseInsensitive) || $0.content.contains(searchWord, options: .caseInsensitive)
//        }
//    }
//
//    func getSearchResult(at index: Int) -> Trip? {
//        guard index < searchResultCount else { return nil }
//        return searchResultList?[index]
//    }
}
