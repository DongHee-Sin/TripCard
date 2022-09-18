//
//  SettingViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit

class SettingViewController: BaseViewController {

    // MARK: - Propertys
    let cellItems = [
        ["폰트 변경", "테마 색 변경"],
        ["백업 / 복원", "초기화"],
        ["버그 리포트 및 피드백", "앱스토어 리뷰 남기기"],
        ["버전 정보", "오픈소스 라이선스"]
    ]
    
    
    
    
    // MARK: - Life Cycle
    let settingView = SettingView()
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
    }
}




// MARK: - TableView Protocol
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellItems.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
        
        return cell
    }
}
