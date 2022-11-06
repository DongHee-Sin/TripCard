//
//  DocumentError.swift
//  TripCard
//
//  Created by 신동희 on 2022/11/06.
//

import Foundation


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




extension DocumentError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .createDirectoryError:
            return "create_directory_error".localized
        case .saveImageError:
            return "save_image_error".localized
        case .removeDirectoryError:
            return "delete_directory_error".localized
        case .removeFileError:
            return "delete_file_error".localized
        case .fetchImagesError:
            return "fetch_image_error".localized
        case .fetchZipFileError:
            return "fetch_zip_file_error".localized
        case .fetchDirectoryPathError:
            return "fetch_directory_path_error".localized
        case .fetchJsonDataError:
            return "fetch_json_file_error".localized
        case .compressionFailedError:
            return "compression_file_error".localized
        case .restoreFailedError:
            return "restore_file_error".localized
        }
    }
    
}
