//
//  CalendarSheetViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit

import FSCalendar


protocol AddPeriodDelegate: AnyObject {
    func addPeriod(period: TripPeriod?)
}



final class CalendarSheetViewController: BaseViewController {

    // MARK: - Propertys
    var halfDeviceHeight: CGFloat = 0
    
    private var period: TripPeriod?
    
    weak var delegate: AddPeriodDelegate?
    
    
    
    
    // MARK: - Life Cycle
    private let calendarView = CalendarView()
    override func loadView() {
        self.view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.addPeriod(period: period)
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
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
    
    
    private func selectedDateDidChanged(selectedDates: [Date]) {
        period = convertDateArrayToTripPeriod(dates: selectedDates)
    
        updateCalendarLabel(period: period)
    }
    
    
    private func updateCalendarLabel(period: TripPeriod?) {
        guard let period = period else {
            calendarView.selectedDateLabel.text = "trip_period_string".localized
            return
        }
        
        if period.start == period.end {
            calendarView.selectedDateLabel.text = period.start.string
        }else {
            calendarView.selectedDateLabel.text = period.start.string + " ~ " + period.end.string
        }
    }
    
    
    func calendarInitialSetting(viewModel: WriteViewModel) {
        period = viewModel.tripPeriod.value
        
        updateCalendarLabel(period: period)
        
        guard let period = period else { return }
        
        selectDates(period: period)
        calendarView.calendar.setCurrentPage(period.start, animated: true)
    }
    
    
    private func selectDates(period: TripPeriod) {
        let calendar = calendarView.calendar

        var startTemp = period.start
        while startTemp <= period.end {
            calendar.select(startTemp)
            startTemp += 86400
        }
    }
    
    
    private func convertDateArrayToTripPeriod(dates: [Date]) -> TripPeriod? {
        if dates.isEmpty {
            return nil
        }else {
            return (dates.first!, dates.last!)
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
            if calendar.selectedDates[0] > calendar.selectedDates[1] {
                calendar.deselect(calendar.selectedDates[0])
            }else {
                if let period = convertDateArrayToTripPeriod(dates: calendar.selectedDates) {
                    selectDates(period: period)
                }
            }
        default: break
        }
        
        selectedDateDidChanged(selectedDates: calendar.selectedDates.sorted())
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.selectedDates.forEach {
            calendar.deselect($0)
        }
        
        calendar.select(date)
        
        selectedDateDidChanged(selectedDates: calendar.selectedDates.sorted())
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return calendar.currentPage.isInSameMonth(as: date) ? true : false
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarView.changeMonthView.dateLabel.text = "month".localized(number: calendar.currentPage.get(.month))
        calendarView.changeYearView.dateLabel.text = "year".localized(number: calendar.currentPage.get(.year))
    }
}
