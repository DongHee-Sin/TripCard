//
//  ChangeColorViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


final class ChangeColorViewController: BaseViewController {

    // MARK: - Propertys
    let currentThemeColor = ThemeColor(rawValue: UserDefaultManager.shared.themeColor)
    
    let themeColorList = ThemeColor.allCases
    
    
    
    
    // MARK: - Life Cycle
    let changeColorView = ReusableTableCustomView()
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
        
        navigationItem.title = "테마 색상 변경"
    }
}




// MARK: - TableView Protocol
extension ChangeColorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "변경하고 싶은 테마 색상을 선택하세요!"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeColorList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let themeColor = themeColorList[indexPath.row]
        cell.textLabel?.text = themeColor.rawValue
        cell.textLabel?.font = .customFont(size: .normal)
        
        if let currentThemeColor = currentThemeColor {
            if currentThemeColor == themeColor {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeColor = themeColorList[indexPath.row]
        
        
        if let currentThemeColor = currentThemeColor {
            if currentThemeColor == themeColor {
                showAlert(title: "이미 적용중인 테마 색상이에요!")
                return
            }
        }
        
        
        showAlert(title: "\(themeColor.rawValue)(으)로 테마 색상을 변경하시겠어요?", buttonTitle: "네!", cancelTitle: "아뇨!") { _ in
            UserDefaultManager.shared.themeColor = themeColor.rawValue
            ColorManager.themeColorChanged()
            self.changeRootViewController()
        }
    }
}
