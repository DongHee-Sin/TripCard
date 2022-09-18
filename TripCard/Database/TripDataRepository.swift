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
    func create(_ trip: Trip, mainImage: UIImage, imageByDate: [UIImage?]) throws
    
    func fetchTrip(at index: Int, isDomestic: Bool) -> Trip?
    
    func update(trip: Trip, completion: (Trip) -> Void) throws
    
    func remove(trip: Trip) throws
    
    func addObserver(completion: @escaping () -> Void)
    
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
    private var tripNotificationToken: NotificationToken?
    
    
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
    func create(_ trip: Trip, mainImage: UIImage, imageByDate: [UIImage?]) throws {
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
    func fetchTrip(at index: Int, isDomestic: Bool) -> Trip? {
        if isDomestic {
            guard index < domesticCount else { return nil }
            return domesticList[index]
        }else {
            guard index < overseasCount else { return nil }
            return overseasList[index]
        }
    }
    
    
    
    // Update
    func update(trip: Trip, completion: (Trip) -> Void) throws {
        do {
            try localRealm.write({
                completion(trip)
            })
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    
    // Delete
    func remove(trip: Trip) throws {
        do {
            try localRealm.write {
                localRealm.delete(trip)
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
    
    
    
    // Observer 달기
    func addObserver(completion: @escaping () -> Void) {
        tripNotificationToken = totalTripList.observe { _ in
            completion()
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
