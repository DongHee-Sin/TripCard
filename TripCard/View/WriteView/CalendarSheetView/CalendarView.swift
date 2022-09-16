//
//  CalendarView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/15.
//

import UIKit
import FSCalendar


final class CalendarView: BaseView {
    
    // MARK: - Propertys
    let calendar = FSCalendar().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        
        $0.today = nil
        $0.appearance.selectionColor = ColorManager.shared.buttonColor
        $0.appearance.weekdayFont = .customFont(size: .normal)
        $0.appearance.titleFont = .customFont(size: .small)
        $0.appearance.headerTitleFont = .customFont(size: .normal)
        
        $0.appearance.titleWeekendColor = .red
        $0.allowsMultipleSelection = true
//        $0.swipeToChooseGesture.isEnabled = true
    }
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(calendar)
    }
    
    
    override func setConstraint() {
        calendar.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
}















// MARK: - 참고 코드
class CalendarViewController: UIViewController {
    
    var calendar = FSCalendar()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
//    var delagate: textFieldend!
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.appearance.selectionColor = #colorLiteral(red: 0.9215686275, green: 0.2431372549, blue: 0.137254902, alpha: 1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        
        
        calendar.allowsMultipleSelection = true
        calendar.appearance.borderRadius = 0

        calendar.today = nil // Hide the today circle
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
    }
}



extension CalendarViewController:  FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {//달력 일정 날짜 선택했을 때
        if calendar.selectedDates.count > 2{
            for _ in 0 ..< calendar.selectedDates.count - 1{
                calendar.deselect(calendar.selectedDates[0])
            }
        }
        
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
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) { //선택날짜 한번 더 누를 때
        
        for _ in 0 ..< calendar.selectedDates.count {
            calendar.deselect(calendar.selectedDates[0])
        }
        calendar.select(date)
    }
    
}
