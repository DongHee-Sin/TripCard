//
//  WriteViewModel.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit


class WriteViewModel {
    
    // MARK: - Propertys
    var segmentValue: Observable<Int> = Observable(0)
    var photoImage: Observable<UIImage> = Observable(UIImage())

}
