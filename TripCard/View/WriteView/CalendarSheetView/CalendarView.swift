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
    let selectedDateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
    }
    
    let changeDateStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 35
        $0.axis = .horizontal
    }
    
    let changeMonthView = ChangeCalendarDateView()
    
    let changeYearView = ChangeCalendarDateView()
    
    let calendar = FSCalendar().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        
        $0.today = nil
        $0.appearance.selectionColor = ColorManager.shared.buttonColor
        $0.appearance.weekdayFont = .customFont(size: .normal)
        $0.appearance.titleFont = .customFont(size: .small)
        $0.appearance.headerTitleFont = .customFont(size: .normal)
        $0.appearance.titleWeekendColor = .red
        
        $0.headerHeight = 0
        $0.calendarHeaderView.isHidden = true
    
        $0.allowsMultipleSelection = true
    }
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [changeMonthView, changeYearView].forEach {
            changeDateStackView.addArrangedSubview($0)
        }
        
        [selectedDateLabel, changeDateStackView, calendar].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        selectedDateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(20)
            make.top.equalTo(self.snp.top).offset(12)
            make.height.equalTo(24)
        }
        
        changeDateStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(20)
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(12)
            make.height.equalTo(24)
        }
        
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(20)
            make.top.equalTo(changeDateStackView.snp.bottom).offset(12)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
}
