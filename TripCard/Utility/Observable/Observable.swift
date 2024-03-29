//
//  Observable.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import Foundation


class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
