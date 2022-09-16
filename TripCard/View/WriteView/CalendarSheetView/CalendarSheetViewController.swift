//
//  CalendarSheetViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit

import FSCalendar
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
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
}




// MARK: - FSCalendar Protocol
extension CalendarSheetViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        switch calendar.selectedDates.count {
        case 3...:
            for _ in 0..<calendar.selectedDates.count {
                calendar.deselect(calendar.selectedDates[0])
            }
        case 2:
            var startTemp: Date!
            if calendar.selectedDates.count == 2{
                if calendar.selectedDates[0] < calendar.selectedDates[1]{
                    startTemp = calendar.selectedDates[0]
                    while startTemp < calendar.selectedDates[1]-86400{
                        startTemp += 86400
                        calendar.select(startTemp)
                    }
                    startTemp = nil
                }
                else{
                    startTemp = calendar.selectedDates[1]
                    while startTemp < calendar.selectedDates[0] - 86400{
                        startTemp += 86400
                        calendar.select(startTemp)
                    }
                }
            }
        default: break
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.selectedDates.forEach {
            calendar.deselect($0)
        }
        
        calendar.select(date)
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
