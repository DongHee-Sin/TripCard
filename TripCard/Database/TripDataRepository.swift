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
    
    func updateSearchResult(searchWord: String)
    func fetchSearchResult(at index: Int) -> Trip?
}


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}


enum CodableError: Error {
    case jsonDecodeError
    case jsonEncodeError
    
    case noDataToBackupError
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
    
    private lazy var dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        return dateFormatter
    }()
    
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
        try create([trip])
        
        try documentManager.saveImageToDocument(directoryName: trip.objectId.stringValue, mainImage: mainImage, imageByDate: imageByDate)
    }
    
    
    
    func create(_ trip: [Trip]) throws {
        do {
            try localRealm.write {
                localRealm.add(trip)
            }
        }
        catch {
            throw RealmError.writeError
        }
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
    
    
    
    private func removeAllRealmData() throws {
        do {
            try localRealm.write {
                localRealm.deleteAll()
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
    
    
    
    func resetAppData() throws {
        try removeAllRealmData()
        try documentManager.removeAllDocumentData()
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
    
    
    
    func overwriteRealmWithJSON() throws {
        let jsonData = try documentManager.fetchJSONData()
        
        guard let decodedData = try decodeJSON(jsonData) else { return }
        
        try removeAllRealmData()
        try create(decodedData)
    }
    
    
    
    func saveEncodedDataToDocument() throws {
        let encodedData = try encodeTrip(totalTripList)
        
        try documentManager.saveDataToDocument(data: encodedData)
    }
    
    
    
    private func decodeJSON(_ tripData: Data) throws -> [Trip]? {
        do {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let decodedData: [Trip] = try decoder.decode([Trip].self, from: tripData)
            
            return decodedData
        } catch {
            throw CodableError.jsonDecodeError
        }
    }
    
    
    
    private func encodeTrip(_ tripData: Results<Trip>) throws -> Data {
        guard !tripData.isEmpty else { throw CodableError.noDataToBackupError }
        
        do {
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let encodedData: Data = try encoder.encode(tripData)
            
            return encodedData
        }
        catch {
            throw CodableError.jsonEncodeError
        }
        
    }
    
    
    
    // SearchController
    func updateSearchResult(searchWord: String) {
        searchResultList = totalTripList.where {
            $0.location.contains(searchWord, options: .caseInsensitive)
        }
    }

    func fetchSearchResult(at index: Int) -> Trip? {
        guard index < searchResultCount else { return nil }
        return searchResultList?[index]
    }
}
