//
//  URL+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/23.
//

import Foundation


extension URL {
    
    var pathString: String {
        if #available(iOS 16, *) {
            return self.path()
        }else {
            return self.path
        }
    }
    
}
