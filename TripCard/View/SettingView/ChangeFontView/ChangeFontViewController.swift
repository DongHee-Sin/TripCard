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
        
        navigationItem.title = "폰트 변경"
    }
}




// MARK: - TableView Protocol
extension ChangeFontViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "변경하고 싶은 폰트를 선택하세요!"
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
                showAlert(title: "이미 적용중인 폰트네요!")
                return
            }
        }
        
        
        showAlert(title: "\(font.rawValue) 폰트로 변경하시겠어요?", buttonTitle: "네!", cancelTitle: "아뇨!") { _ in
            UserDefaultManager.shared.customFont = font.rawValue
            self.changeRootViewController()
        }
    }
}
