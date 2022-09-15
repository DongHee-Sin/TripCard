//
//  CalendarSheetViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit
import PanModal


final class CalendarSheetViewController: BaseViewController {

    // MARK: - Propertys
    var halfDeviceHeight: CGFloat = 0
    
    
    
    
    // MARK: - Life Cycle
    private let calendarView = CalendarView()
    override func loadView() {
        self.view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        
    }
}




// MARK: - PanModal Protocol
extension CalendarSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(halfDeviceHeight)
    }
    
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(halfDeviceHeight)
    }
    
    
    var panModalBackgroundColor: UIColor {
        return .black.withAlphaComponent(0.5)
    }

    
    
}
