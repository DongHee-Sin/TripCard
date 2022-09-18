//
//  SettingView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class SettingView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView(frame: CGRect(), style: .insetGrouped).then {
        $0.backgroundColor = .clear
    }
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
