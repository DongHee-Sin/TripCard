//
//  SettingViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit


enum SettingCellList: String {
    case changeFont = "폰트 변경"
    case changeThemeColor = "테마 색 변경"
    case backUpAndRestore = "백업 / 복원"
    case reset = "초기화"
    case bugReportAndFeedback = "버그 리포트 및 피드백"
    case appStoreReview = "앱스토어 리뷰 남기기"
    case versionInfo = "버전 정보"
    case openSource = "오픈소스 라이선스"
}


class SettingViewController: BaseViewController {

    // MARK: - Propertys
    private let cellItems: [[SettingCellList]] = [
        [.changeFont, .changeThemeColor],
        [.backUpAndRestore, .reset],
        [.bugReportAndFeedback, .appStoreReview],
        [.versionInfo, .openSource]
    ]
    
    
    
    
    // MARK: - Life Cycle
    private let settingView = ReusableTableCustomView()
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
        
        navigationItem.title = "설정"
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
        
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row].rawValue
        cell.textLabel?.font = .customFont(size: .large)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = cellItems[indexPath.section][indexPath.row]
        
        var selectedVC: UIViewController?
        
        switch selectedCell {
        case .changeFont: selectedVC = ChangeFontViewController()
        case .changeThemeColor: selectedVC = ChangeColorViewController()
        case .backUpAndRestore: selectedVC = BackupRestoreViewController()
        case .reset: break
        case .bugReportAndFeedback: break
        case .appStoreReview: break
        case .versionInfo: break
        case .openSource: break
        }
        
        if let selectedVC = selectedVC {
            transition(selectedVC, transitionStyle: .push)
        }
    }
}
