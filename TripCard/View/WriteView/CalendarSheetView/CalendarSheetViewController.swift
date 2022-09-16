//
//  CalendarSheetViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit

import FSCalendar
import PanModal


protocol AddPeriodDelegate: AnyObject {
    func addPeriod(dates: [Date])
}



final class CalendarSheetViewController: BaseViewController {

    // MARK: - Propertys
    var halfDeviceHeight: CGFloat = 0
    
    var delegate: AddPeriodDelegate?
    
    
    
    
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
        selectedDateDidChanged()
        calendarCurrentPageDidChange(calendarView.calendar)
        
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
        
        setAddTarget()
    }
    
    
    private func setAddTarget() {
        calendarView.changeMonthView.backButton.addTarget(self, action: #selector(moveMonthButtonTapped), for: .touchUpInside)
        calendarView.changeMonthView.nextButton.addTarget(self, action: #selector(moveMonthButtonTapped), for: .touchUpInside)
        calendarView.changeYearView.backButton.addTarget(self, action: #selector(moveYearButtonTapped), for: .touchUpInside)
        calendarView.changeYearView.nextButton.addTarget(self, action: #selector(moveYearButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func moveMonthButtonTapped(button: UIButton) {
        let isNext = button == calendarView.changeMonthView.nextButton
        var dateComponents = DateComponents()
        dateComponents.month = isNext ? 1 : -1
        
        updateCalendarCurrentPage(dateComponents: dateComponents)
    }
    
    
    @objc private func moveYearButtonTapped(button: UIButton) {
        let isNext = button == calendarView.changeYearView.nextButton
        var dateComponents = DateComponents()
        dateComponents.year = isNext ? 1 : -1
        
        updateCalendarCurrentPage(dateComponents: dateComponents)
    }
    
    
    private func updateCalendarCurrentPage(dateComponents: DateComponents) {
        let calendar = Calendar.current
        let changedPage = calendar.date(byAdding: dateComponents, to: calendarView.calendar.currentPage) ?? Date()
        
        calendarView.calendar.setCurrentPage(changedPage, animated: true)
    }
    
    
    private func selectedDateDidChanged() {
        let selectedDates = calendarView.calendar.selectedDates
        
        delegate?.addPeriod(dates: selectedDates)
        updateCalendarSelectedLabel(dates: selectedDates)
    }
    
    
    private func updateCalendarSelectedLabel(dates: [Date]) {
        if dates.isEmpty {
            calendarView.selectedDateLabel.text = "여행 기간"
        }else if dates.count == 1 {
            calendarView.selectedDateLabel.text = dates[0].string
        }else {
            calendarView.selectedDateLabel.text = dates.first!.string + " ~ " + dates.last!.string
        }
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
        
        selectedDateDidChanged()
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.selectedDates.forEach {
            calendar.deselect($0)
        }
        
        calendar.select(date)
        
        selectedDateDidChanged()
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarView.changeMonthView.dateLabel.text = "\(calendar.currentPage.get(.month))월"
        calendarView.changeYearView.dateLabel.text = "\(calendar.currentPage.get(.year))년"
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
