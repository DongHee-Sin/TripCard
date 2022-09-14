//
//  WriteView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit


final class WriteView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView(frame: CGRect(), style: .grouped).then {
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .clear
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
