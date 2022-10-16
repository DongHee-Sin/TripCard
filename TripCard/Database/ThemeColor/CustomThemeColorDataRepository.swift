//
//  CustomThemeColorDataRepository.swift
//  TripCard
//
//  Created by 신동희 on 2022/10/13.
//

import Foundation

import RealmSwift


protocol CustomThemeColorDataRepositoryType {
    func create(_ customThemeColor: CustomThemeColor) throws
    func fetch(at index: Int) -> CustomThemeColor?
    func update(_ customThemeColor: CustomThemeColor, completion: (CustomThemeColor) -> Void) throws
    func remove(_ customThemeColor: CustomThemeColor) throws
}


final class CustomThemeColorDataRepository: CustomThemeColorDataRepositoryType {
    
    // MARK: - Propertys
    static let shared = CustomThemeColorDataRepository()
    
    private let localRealm = try! Realm()
    
    private var customThemeColorList: Results<CustomThemeColor>
    
    var count: Int {
        return customThemeColorList.count
    }
    
    
    
    
    // MARK: - Init
    private init() {
        customThemeColorList = localRealm.objects(CustomThemeColor.self).sorted(byKeyPath: "title")
    }
    
    
    
    
    // MARK: - Methods
    // Create(add)
    func create(_ customThemeColor: CustomThemeColor) throws {
        do {
            try localRealm.write {
                localRealm.add(customThemeColor)
            }
        }
        catch {
            throw RealmError.writeError
        }
    }
    
    
    // Read
    func fetch(at index: Int) -> CustomThemeColor? {
        guard index < count else { return nil }
        return customThemeColorList[index]
    }
    
    
    // Update
    func update(_ customThemeColor: CustomThemeColor, completion: (CustomThemeColor) -> Void) throws {
        do {
            try localRealm.write {
                completion(customThemeColor)
            }
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    // Delete
    func remove(_ customThemeColor: CustomThemeColor) throws {
        do {
            try localRealm.write {
                localRealm.delete(customThemeColor)
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
}
