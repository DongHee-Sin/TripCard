//
//  CalendarSheetViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit

final class CalendarSheetViewController: BaseViewController {

    // MARK: - Life Cycle
    let calendarView = CalendarView()
    override func loadView() {
        self.view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
