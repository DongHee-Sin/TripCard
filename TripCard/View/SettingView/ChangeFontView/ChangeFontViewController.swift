//
//  ChangeFontViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class ChangeFontViewController: BaseViewController {

    // MARK: - Propertys
    private let currentFont = CustomFont(rawValue: UserDefaultManager.shared.customFont)
    
    private let customFontList = CustomFont.allCases
    
    
    
    
    // MARK: - Life Cycle
    private let changeFontView = ReusableTableCustomView()
    override func loadView() {
        self.view = changeFontView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        changeFontView.tableView.delegate = self
        changeFontView.tableView.dataSource = self
        
        navigationItem.title = "change_font".localized
    }
}




// MARK: - TableView Protocol
extension ChangeFontViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_font_view_header_title".localized
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customFontList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell()
        
        let font = customFontList[indexPath.row]
        cell.textLabel?.text = font.rawValue
        cell.textLabel?.font = .customFont(font: font, size: .large)
        
        if let currentFont = currentFont {
            if currentFont == font {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let font = customFontList[indexPath.row]
        
        
        if let currentFont = currentFont {
            if currentFont == font {
                showAlert(title: "already_applied_font_alert_title".localized)
                return
            }
        }
        
        
        showAlert(title: "change_font_alert_title".localized(with: font.rawValue), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { _ in
            UserDefaultManager.shared.customFont = font.rawValue
            self.changeRootViewController()
        }
    }
}
