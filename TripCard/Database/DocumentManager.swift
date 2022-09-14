//
//  DocumentManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit


enum DocumentError: Error {
    case createDirectoryError
    case saveImageError
    case removeDirectoryError
    case fetchImagesError
    case fetchZipFileError
}


struct DocumentManager {
    
    private func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    
    
    func createImagesDirectory() throws {
        guard let path = documentDirectoryPath() else { return }

        let imagesPath = path.appendingPathComponent("images")

        if !FileManager.default.fileExists(atPath: imagesPath.path) {
            do {
                try FileManager.default.createDirectory(at: imagesPath, withIntermediateDirectories: true)
            }
            catch {
                throw DocumentError.createDirectoryError
            }
        }else {
            print("images directory 이미 있다!")
        }
    }
    
    
    
    private func createDirectory(directoryName: String) throws {
        guard let documentDirectory = documentDirectoryPath() else { return }

        let imagesPath = documentDirectory.appendingPathComponent("images")
        
        let directoryPathForCreate = imagesPath.appendingPathComponent(directoryName)

        if !FileManager.default.fileExists(atPath: directoryPathForCreate.path) {
            do {
                try FileManager.default.createDirectory(at: directoryPathForCreate, withIntermediateDirectories: true)
            }
            catch {
                throw DocumentError.createDirectoryError
            }
        }else {
            print("directory 이미 있다!")
        }
    }
    
    
    
    func saveImageToDocument(directoryName: String, images: [UIImage]) throws {
        guard let documentDirectory = documentDirectoryPath() else { return }
        let imagesPath = documentDirectory.appendingPathComponent("images", isDirectory: true)
        
        try createDirectory(directoryName: directoryName)
    
        let directoryPath = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        let result = images.enumerated().map { index, image in
            let fileURL = directoryPath.appendingPathComponent("image\(index).jpg")
            let imageData = image.jpegData(compressionQuality: 0.3) ?? Data()
            
            let result = (fileURL: fileURL, imageData: imageData)
            
            return result
        }
        
        try result.forEach {
            do {
                try $0.imageData.write(to: $0.fileURL)
            }
            catch {
                throw DocumentError.saveImageError
            }
        }
    }
    
    
    
    func removeImageDirectoryFromDocument(directoryName: String) throws {
        guard let documentDirectory = documentDirectoryPath() else { return }
        let imagesPath = documentDirectory.appendingPathComponent("images", isDirectory: true)
        
        let directoryPathForRemove = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        do {
            try FileManager.default.removeItem(at: directoryPathForRemove)
        }catch {
            throw DocumentError.removeDirectoryError
        }
    }
    
    
    
    func loadImagesFromDocument(directoryName: String) throws -> [UIImage?] {
        guard let documentDirectory = documentDirectoryPath() else { return [] }
        let imagesPath = documentDirectory.appendingPathComponent("images")
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        do {
            let imagePaths = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            let images = imagePaths.map { UIImage(contentsOfFile: $0.path) }
            
            return images
        }
        catch {
            throw DocumentError.fetchImagesError
        }
    }
    
    
    
//    func removeFileFromDocument(fileName: String) {
//        guard let documentDirectory = documentDirectoryPath() else { return }
//
//        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
//
//        do {
//            try FileManager.default.removeItem(at: fileURL)
//        }
//        catch let error {
//            print(error)
//        }
//    }
    
    
    
    func fetchDocumentZipFile() throws -> [URL] {
        do {
            guard let path = documentDirectoryPath() else { return [] }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            
            let zip = docs.filter { $0.pathExtension == "zip" }
            
            return zip
            
        }catch {
            throw DocumentError.fetchZipFileError
        }
        
    }
}