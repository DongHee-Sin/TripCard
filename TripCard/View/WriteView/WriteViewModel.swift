//
//  WriteViewModel.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit


struct CardByDate {
    var photoImage: UIImage
    var content: String
}


class WriteViewModel {
    
    // MARK: - Propertys
    var segmentValue: Observable<Int> = Observable(0)
    var photoImage: Observable<UIImage> = Observable(UIImage())
    var tripPeriod: Observable<[Date]> = Observable([])

    // 생성된 cell 개수만큼 Value를 생성하고, 하나씩 업데이트시키는 느낌으로..
    var cardByDate: [Observable<CardByDate>] = []
    
    var periodString: String {
        if tripPeriod.value.isEmpty {
            return ""
        }else if tripPeriod.value.count == 1 {
            return tripPeriod.value[0].string
        }else {
            return tripPeriod.value.first!.string + " ~ " + tripPeriod.value.last!.string
        }
    }
    
    
    // MARK: - Methods
    
}
