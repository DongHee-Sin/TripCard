//
//  DocumentManager.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit

import RealmSwift
import Zip


enum DocumentError: Error {
    case createDirectoryError
    
    case saveImageError
    
    case removeDirectoryError
    case removeFileError
    
    case fetchImagesError
    case fetchZipFileError
    case fetchDirectoryPathError
    case fetchJsonDataError
    
    case compressionFailedError
    case restoreFailedError
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
        
        let imageQuality = UserDefaultManager.shared.imageQuality
        
        // 메인 이미지
        let result = {
            let fileURL = directoryPath.appendingPathComponent("mainImage.jpg")
            let imageData = mainImage?.jpegData(compressionQuality: imageQuality)
            
            return (fileURL: fileURL, imageData: imageData)
        }()
        
        
        // 날짜별 이미지
        let resultByDate = imageByDate.enumerated().map { index, image in
            let fileURL = directoryPath.appendingPathComponent("day\(index + 1)Image.jpg")
            let imageData = image?.jpegData(compressionQuality: imageQuality)
            
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
        
        let image = UIImage(contentsOfFile: mainImagePath.pathString)
        
        return image
    }
    
    
    
    func loadImagesFromDocument(directoryName: String, numberOfTripDate: Int) throws -> [UIImage?] {
        guard let imagesPath = imageDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let directoryURL = imagesPath.appendingPathComponent(directoryName, isDirectory: true)

        let resultImages = (1...numberOfTripDate).map {
            let eachImageURL = directoryURL.appendingPathComponent("day\($0)Image.jpg")
            
            return UIImage(contentsOfFile: eachImageURL.pathString)
        }
        
        return resultImages
    }
    
    
    
    func removeFileFromDocument(fileName: String) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }

        let fileURL = documentPath.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
        }
        catch {
            throw DocumentError.removeFileError
        }
    }
    
    
    
    func removeFileFromDocument(url: URL) throws {
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            throw DocumentError.removeFileError
        }
    }
    
    
    
    func removeAllDocumentData() throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        do {
            let content = try fetchAllContent(at: documentPath)
            
            for url in content {
                try removeFileFromDocument(url: url)
            }
        }
        catch {
            throw DocumentError.removeFileError
        }
    }
    
    
    
    func createBackupFile() throws -> URL {
        var urlPaths: [URL] = []
        
        let documentPath = documentDirectoryPath()
        
        let encodedFilePath = documentPath?.appendingPathComponent("encodedData.json")
        let imagesDirectoryPath = imageDirectoryPath()
        
        guard let realmFilePath = encodedFilePath, let imagesDirectoryPath = imagesDirectoryPath else {
            throw DocumentError.fetchDirectoryPathError
        }
        
        guard isFileExist(path: realmFilePath) && isFileExist(path: imagesDirectoryPath) else {
            throw DocumentError.compressionFailedError
        }
        
        urlPaths.append(contentsOf: [realmFilePath, imagesDirectoryPath])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "TripCard\(Date().backupFileTitle)")
            
            return zipFilePath
        }
        catch {
            throw DocumentError.compressionFailedError
        }
    }
    
    
    
    func fetchDocumentZipFile() throws -> [URL] {
        do {
            guard let path = documentDirectoryPath() else { return [] }
            
            let docs = try fetchAllContent(at: path)
            
            let zip = docs.filter { $0.pathExtension == "zip" }
            
            return zip
            
        }catch {
            throw DocumentError.fetchZipFileError
        }
    }
    
    
    
    func fetchAllContent(at path: URL) throws -> [URL] {
        let content = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        return content
    }
    
    
    
    func fetchJSONData() throws -> Data {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let jsonDataPath = documentPath.appendingPathComponent("encodedData.json")
        
        do {
            return try Data(contentsOf: jsonDataPath)
        }
        catch {
            throw DocumentError.fetchJsonDataError
        }
    }
    
    
    
    private func isFileExist(path: URL) -> Bool {
        let urlString = path.pathString

        return FileManager.default.fileExists(atPath: urlString)
    }
    
    
    
    func saveDataToDocument(data: Data) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let jsonDataPath = documentPath.appendingPathComponent("encodedData.json")
        
        try data.write(to: jsonDataPath)
    }
    
    
    
    func restoreData(zipLastPath: String) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let fileURL = documentPath.appendingPathComponent(zipLastPath)
        
        try unzipFile(fileURL: fileURL, documentURL: documentPath)
    }
    
    
    
    private func unzipFile(fileURL: URL, documentURL: URL) throws {
        do {
            try Zip.unzipFile(fileURL, destination: documentURL, overwrite: true, password: nil, progress: { progress in
                print(progress)
            }, fileOutputHandler: { unzippedFile in
            })
        }
        catch {
            throw DocumentError.restoreFailedError
        }
    }
    
    
    
    func fetchZipFileFromDocumentPicker(selectedFileURL: URL) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentError.fetchDirectoryPathError }
        
        let pathToSaveFile = documentPath.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        do {
            try FileManager.default.copyItem(at: selectedFileURL, to: pathToSaveFile)
        }
        catch {
            throw DocumentError.fetchZipFileError
        }
    }
}
