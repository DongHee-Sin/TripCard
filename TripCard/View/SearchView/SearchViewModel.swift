//
//  SearchViewModel.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/29.
//

import UIKit


struct SearchViewModel {
    
    // MARK: - Propertys
    private let repository = TripDataRepository.shared
    
    var searchKeyWord: Observable<String?> = Observable(nil)
    
    
    var numberOfItemsInSection: Int {
        return repository.searchResultCount
    }
    
    
    
    
    // MARK: - Methdos
    func updateSearchResult() {
        repository.updateSearchResult(searchWord: searchKeyWord.value ?? "")
    }
    
    
    func fetchTripData(at index: Int) throws -> (trip: Trip, image: UIImage?)? {
        
        if let trip = repository.fetchSearchResult(at: index) {
            let image: UIImage? = try repository.documentManager.loadMainImageFromDocument(directoryName: trip.objectId.stringValue)
            
            return (trip, image)
            
        }else {
            return nil
        }
    }
    
    
    func selectedIndexInRealm(at index: Int, tripType: TripType) -> Int? {
        guard let trip = repository.fetchSearchResult(at: index) else {
            return nil
        }
        
        return repository.findIndex(objectID: trip.objectId, tripType: tripType)
    }
    
    
    func fetchTripType(at index: Int) -> TripType? {
        guard let trip = repository.fetchSearchResult(at: index) else { return nil }
        
        return trip.isDomestic ? .domestic : .overseas
    }
}
