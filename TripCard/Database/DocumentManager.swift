//
//  DocumentManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit
import Zip


enum DocumentError: Error {
    case createDirectoryError
    case saveImageError
    case removeDirectoryError
    case fetchImagesError
    case fetchZipFileError
    case fetchDirectoryPathError
    
    case compressionFailedError
}


struct DocumentManager {
    
    private func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    
    private func imageDirectoryPath() -> URL? {
        guard let documentPath = documentDirectoryPath() else { return nil }
        let imagesDirectoryPath = documentPath.appendingPathComponent("images")
        
        return imagesDirectoryPath
    }
    
    
    
    func createImagesDirectory() throws {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }

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
    
    
    
    private func createEachCardDirectory(directoryName: String) throws {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
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
    
    
    
    func saveImageToDocument(directoryName: String, mainImage: UIImage?, imageByDate: [UIImage?]) throws {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        try createEachCardDirectory(directoryName: directoryName)
    
        let directoryPath = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        
        // 메인 이미지
        let result = {
            let fileURL = directoryPath.appendingPathComponent("mainImage.jpg")
            let imageData = mainImage?.jpegData(compressionQuality: 0.3)
            
            return (fileURL: fileURL, imageData: imageData)
        }()
        
        
        // 날짜별 이미지
        let resultByDate = imageByDate.enumerated().map { index, image in
            let fileURL = directoryPath.appendingPathComponent("day\(index + 1)Image.jpg")
            let imageData = image?.jpegData(compressionQuality: 0.3)
            
            let result = (fileURL: fileURL, imageData: imageData)
            
            return result
        }

        
        // 이미지 저장
        do {
            if let imageData = result.imageData {
                try imageData.write(to: result.fileURL)
            }
            
            try resultByDate.forEach {
                guard let imageData = $0.imageData else { return }
                try imageData.write(to: $0.fileURL)
            }
        }
        catch {
            throw DocumentError.saveImageError
        }
    }
    
    
    
    func removeImageDirectoryFromDocument(directoryName: String) throws {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryPathForRemove = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        do {
            try FileManager.default.removeItem(at: directoryPathForRemove)
        }catch {
            throw DocumentError.removeDirectoryError
        }
    }
    
    
    
    func updateImage(directoryName: String, mainImage: UIImage?, imageByDate: [UIImage?]) throws {
        try removeImageDirectoryFromDocument(directoryName: directoryName)
        try saveImageToDocument(directoryName: directoryName, mainImage: mainImage, imageByDate: imageByDate)
    }
    
    
    
    func loadMainImageFromDocument(directoryName: String) throws -> UIImage? {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        let mainImagePath = directoryURL.appendingPathComponent("mainImage.jpg")
        
        var image: UIImage?
        if #available(iOS 16, *) {
            image = UIImage(contentsOfFile: mainImagePath.path())
        }else {
            image = UIImage(contentsOfFile: mainImagePath.path)
        }
        
        return image
    }
    
    
    
    func loadImagesFromDocument(directoryName: String, numberOfTripDate: Int) throws -> [UIImage?] {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)

        let resultImages = (1...numberOfTripDate).map {
            let eachImageURL = directoryURL.appendingPathComponent("day\($0)Image.jpg")
            
            if #available(iOS 16, *) {
                return UIImage(contentsOfFile: eachImageURL.path())
            }else {
                return UIImage(contentsOfFile: eachImageURL.path)
            }
        }
        
        return resultImages
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
    
    
    
    func createBackupFile() throws -> URL {
        var urlPaths: [URL] = []
        
        let documentPath = documentDirectoryPath()
        
        let realmFilePath = documentPath?.appendingPathComponent("default.realm")
        let imagesDirectoryPath = imageDirectoryPath()
        
        guard let realmFilePath = realmFilePath, let imagesDirectoryPath = imagesDirectoryPath else {
            throw DocumentError.fetchDirectoryPathError
        }
        
        guard isFileExist(path: realmFilePath) && isFileExist(path: imagesDirectoryPath) else {
            throw DocumentError.compressionFailedError
        }
        
        urlPaths.append(contentsOf: [realmFilePath, imagesDirectoryPath])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "TripCard-\(Date().string)")
            
            return zipFilePath
        }
        catch {
            throw DocumentError.compressionFailedError
        }
    }
    
    
    
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
    
    
    
    private func isFileExist(path: URL) -> Bool {
        var urlString: String?
        
        if #available(iOS 16, *) {
            urlString = path.path()
        }else {
            urlString = path.path
        }

        return FileManager.default.fileExists(atPath: urlString ?? "")
    }
}
