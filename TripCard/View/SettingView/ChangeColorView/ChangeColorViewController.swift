//
//  ChangeColorViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


enum ThemeType {
    case custom
    case basics
}


final class ChangeColorViewController: BaseViewController {

    // MARK: - Propertys
    private let repository = CustomThemeColorDataRepository.shared
    
    private var themeType: ThemeType = .basics
    
    private let currentThemeColor = ThemeColor(rawValue: UserDefaultManager.shared.themeColor)
    
    private let themeColorList = ThemeColor.allCases
    
    
    
    
    // MARK: - Life Cycle
    private let changeColorView = ReusableTableCustomView()
    override func loadView() {
        self.view = changeColorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        changeColorView.tableView.delegate = self
        changeColorView.tableView.dataSource = self
        
        navigationItem.title = "change_theme_color".localized
    }
}




// MARK: - TableView Protocol
extension ChangeColorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_theme_color_view_header_title".localized
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? repository.count : themeColorList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell()
        
        if indexPath.section == 0 {
            guard let customThemeColor = repository.fetch(at: indexPath.row) else { return cell }
            cell.textLabel?.text = customThemeColor.title
            
        }else {
            let themeColor = themeColorList[indexPath.row]
            cell.textLabel?.text = themeColor.rawValue
            
            if themeType == .basics, let currentThemeColor = currentThemeColor {
                if currentThemeColor == themeColor {
                    cell.accessoryType = .checkmark
                }
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeColor = themeColorList[indexPath.row]
        
        
        if themeType == .basics, let currentThemeColor = currentThemeColor {
            if currentThemeColor == themeColor {
                showAlert(title: "already_applied_theme_color_alert_title".localized)
                return
            }
        }
        
        
        showAlert(title: "change_theme_color_alert_title".localized(with: themeColor.rawValue), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            
            if indexPath.section == 0 {
                self.themeType = .custom
                
                
            }else {
                self.themeType = .basics
                UserDefaultManager.shared.themeColor = themeColor.rawValue
                ColorManager.themeColorChanged()
                self.changeRootViewController()
            }
        }
    }
}
