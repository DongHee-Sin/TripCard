//
//  CodableError.swift
//  TripCard
//
//  Created by 신동희 on 2022/11/06.
//

import Foundation


enum CodableError: Error {
    case jsonDecodeError
    case jsonEncodeError
    case noDataToBackupError
}




extension CodableError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .jsonDecodeError:
            return "json_decode_error".localized
        case .jsonEncodeError:
            return "json_encode_error".localized
        case .noDataToBackupError:
            return "no_data_to_backup".localized
        }
    }
    
}
