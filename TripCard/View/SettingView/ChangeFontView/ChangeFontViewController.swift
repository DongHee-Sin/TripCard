//
//  ChangeFontViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class ChangeFontDataSource: UITableViewDiffableDataSource<Int, CustomFont> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_font_view_header_title".localized
    }
}


final class ChangeFontViewController: BaseViewController {

    // MARK: - Propertys
    private let currentFont = CustomFont(rawValue: UserDefaultManager.shared.customFont)
    
    private let customFontList = CustomFont.allCases
    
    private var dataSource: ChangeFontDataSource!
    
    
    
    
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
        configureDataSource()
        
        changeFontView.tableView.delegate = self
        
        navigationItem.title = "change_font".localized
    }
    
    
    private func createCellConfiguration(cell: UITableViewCell, indexPath: IndexPath) -> UIListContentConfiguration {
        let font = customFontList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = font.rawValue
        content.textProperties.color = ColorManager.shared.textColor ?? .black
        content.textProperties.font = .customFont(font: font, size: .large)
        
        if let currentFont = currentFont {
            if currentFont == font {
                cell.accessoryType = .checkmark
            }
        }
        
        return content
    }
}




// MARK: - TableView Datasource
extension ChangeFontViewController {
    
    private func configureDataSource() {
        dataSource = ChangeFontDataSource(tableView: changeFontView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = BaseTableViewCell()
            cell.contentConfiguration = self.createCellConfiguration(cell: cell, indexPath: indexPath)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, CustomFont>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(customFontList)
        
        dataSource.apply(snapshot)
    }
    
}




// MARK: - TableView Delegate
extension ChangeFontViewController: UITableViewDelegate {
    
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
