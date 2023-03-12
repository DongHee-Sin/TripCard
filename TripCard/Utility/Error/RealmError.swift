//
//  RealmError.swift
//  TripCard
//
//  Created by 신동희 on 2022/11/06.
//

import Foundation


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}


extension RealmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .writeError:
            return "create_card_date_error".localized
        case .updateError:
            return "modify_card_date_error".localized
        case .deleteError:
            return "delete_card_date_error".localized
        }
    }
}
