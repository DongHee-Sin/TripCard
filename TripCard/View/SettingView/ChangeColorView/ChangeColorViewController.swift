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
    
    private lazy var themeType: ThemeType = currentCustomThemeColor == "" ? .basics : .custom
    
    // Custom) Realm
    private let currentCustomThemeColor = UserDefaultManager.shared.customThemeColor
    
    // UserDefaults
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
    
    
    private func createCellConfiguration(cell: UITableViewCell, indexPath: IndexPath) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        
        if indexPath.section == 0 {
            if let customThemeColor = repository.fetch(at: indexPath.row) {
                content.text = customThemeColor.title
                
                if themeType == .custom && currentCustomThemeColor == customThemeColor.title {
                    cell.accessoryType = .checkmark
                }
            }
            
        }else {
            let themeColor = themeColorList[indexPath.row]
            content.text = themeColor.rawValue
            
            if themeType == .basics, let currentThemeColor = currentThemeColor {
                if currentThemeColor == themeColor {
                    cell.accessoryType = .checkmark
                }
            }
        }
        
        content.textProperties.color = ColorManager.shared.textColor ?? .black
        content.textProperties.font = .customFont(size: .large)
        
        return content
    }
}




// MARK: - TableView Protocol
extension ChangeColorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && repository.count == 0 {
            return .zero
        }else {
            return 44
        }
    }
    
    
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
        
        cell.contentConfiguration = createCellConfiguration(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            // Custom Theme Color
            guard let themeColor = repository.fetch(at: indexPath.row) else { return }
            
            
            if themeType == .custom && themeColor.title == currentCustomThemeColor {
                showAlert(title: "already_applied_theme_color_alert_title".localized)
                return
            }
            
            
            showAlert(title: "change_theme_color_alert_title".localized(with: themeColor.title), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { [weak self] _ in
                guard let self = self else { return }
                
                UserDefaultManager.shared.customThemeColor = themeColor.title
                
                ColorManager.themeColorChanged(customThemeColor: themeColor)
                self.changeRootViewController()
            }
            
        }else {
            
            // Basic Theme Color
            let themeColor = themeColorList[indexPath.row]
            
            
            if themeType == .basics, let currentThemeColor = currentThemeColor {
                if currentThemeColor == themeColor {
                    showAlert(title: "already_applied_theme_color_alert_title".localized)
                    return
                }
            }
            
            
            showAlert(title: "change_theme_color_alert_title".localized(with: themeColor.rawValue), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { [weak self] _ in
                guard let self = self else { return }
                
                UserDefaultManager.shared.customThemeColor = ""
                
                UserDefaultManager.shared.themeColor = themeColor.rawValue
                ColorManager.themeColorChanged()
                self.changeRootViewController()
            }
        }
    }
}
