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


final class ChangeColorDataSource: UITableViewDiffableDataSource<Int, ThemeColor> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_theme_color_view_header_title".localized
    }
}


final class ChangeColorViewController: BaseViewController {

    // MARK: - Propertys
    private let currentThemeColor = ThemeColor(rawValue: UserDefaultManager.shared.themeColor)

    private let themeColorList = ThemeColor.allCases
    
    private var dataSource: ChangeColorDataSource!




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
        
        configureDataSource()

        navigationItem.title = "change_theme_color".localized
    }


    private func createCellConfiguration(cell: UITableViewCell, indexPath: IndexPath) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        
        let themeColor = themeColorList[indexPath.row]
        
        if currentThemeColor == themeColor {
            cell.accessoryType = .checkmark
        }

        content.text = themeColor.rawValue
        content.textProperties.color = ColorManager.shared.textColor ?? .black
        content.textProperties.font = .customFont(size: .large)

        return content
    }
}




// MARK: - TableView Datasource
extension ChangeColorViewController {
    
    private func configureDataSource() {
        dataSource = ChangeColorDataSource(tableView: changeColorView.tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            let cell = BaseTableViewCell()

            cell.contentConfiguration = self?.createCellConfiguration(cell: cell, indexPath: indexPath)

            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ThemeColor>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(themeColorList)
        
        dataSource.apply(snapshot)
    }
    
}




// MARK: - TableView Delegate
extension ChangeColorViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeColor = themeColorList[indexPath.row]

        if let currentThemeColor = currentThemeColor {
            if currentThemeColor == themeColor {
                showAlert(title: "already_applied_theme_color_alert_title".localized)
                return
            }
        }

        showAlert(title: "change_theme_color_alert_title".localized(with: themeColor.rawValue), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            UserDefaultManager.shared.themeColor = themeColor.rawValue
            ColorManager.themeColorChanged()
            self.changeRootViewController()
        }
        
    }
}
