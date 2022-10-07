//
//  LocationSearchView.swift
//  TripCard
//
//  Created by 신동희 on 2022/10/06.
//

import UIKit


final class LocationSearchView: BaseView {
    
    // MARK: - Propertys
    let searchBar = UISearchBar().then {
        $0.searchTextField.textColor = ColorManager.shared.textColor
        $0.searchTextField.leftView?.tintColor = ColorManager.shared.textColor
        $0.barTintColor = ColorManager.shared.selectedColor
        $0.placeholder = "location_search_placeholder".localized
        $0.showsCancelButton = true
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [searchBar, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(self).inset(0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(self).inset(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
