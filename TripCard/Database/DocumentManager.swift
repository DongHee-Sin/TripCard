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
    case fetchDirectoryPathError
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
    
    
    
    func saveImageToDocument(directoryName: String, mainImage: UIImage, imageByDate: [UIImage?]) throws {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        try createEachCardDirectory(directoryName: directoryName)
    
        let directoryPath = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        
        // 메인 이미지
        let result = {
            let fileURL = directoryPath.appendingPathComponent("mainImage")
            let imageData = mainImage.jpegData(compressionQuality: 0.3) ?? Data()
            
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
            try result.imageData.write(to: result.fileURL)
            
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
    
    
    func loadMainImageFromDocument(directoryName: String) throws -> UIImage? {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        let mainImagePath = directoryURL.appendingPathComponent("mainImage")
        
        var image: UIImage?
        if #available(iOS 16, *) {
            image = UIImage(contentsOfFile: mainImagePath.path())
        }else {
            image = UIImage(contentsOfFile: mainImagePath.path)
        }
        
        return image
    }
    
    
    func loadImagesFromDocument(directoryName: String) throws -> [UIImage?] {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
        
        do {
            let imagePaths = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            let images = imagePaths.map { UIImage(contentsOfFile: $0.path) }
            
            return images
        }
        catch {
            throw DocumentError.fetchImagesError
        }
        
        
        // MARK: - 방법 테스트
//        guard let documentDirectory = documentDirectoryPath() else { return [] }
//        let imagesPath = documentDirectory.appendingPathComponent("images")
//        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)
//
//        // 메인이미지 가져오기
//        //try FileManager.default.contents(atPath: "mainImage")
//
//        [].forEach {
//            let eachImageURL = directoryURL.appendingPathComponent("day\($0)Image")
//            try FileManager.default.contents(atPath: eachImageURL)
//        }
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
