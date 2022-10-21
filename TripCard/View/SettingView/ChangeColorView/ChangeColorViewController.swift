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




// MARK: - TableView Protocol
extension ChangeColorViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_theme_color_view_header_title".localized
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeColorList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell()

        cell.contentConfiguration = createCellConfiguration(cell: cell, indexPath: indexPath)

        return cell
    }


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
