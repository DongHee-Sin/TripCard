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
    let calendar = FSCalendar()
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(calendar)
    }
    
    
    override func setConstraint() {
        calendar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height)
        }
    }
}
