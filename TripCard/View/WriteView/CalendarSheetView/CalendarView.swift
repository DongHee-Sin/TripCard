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
        $0.swipeToChooseGesture.isEnabled = true
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
