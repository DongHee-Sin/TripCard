//
//  SettingViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit

import AcknowList
import MessageUI


enum SettingCellList: String {
    case changeFont = "change_font"
    case changeThemeColor = "change_theme_color"
    case changeImageQuality = "change_image_quality"
    case backUpAndRestore = "backup_and_restore"
    case reset = "reset"
    case bugReportAndFeedback = "bug_report_and_feedback"
    case appStoreReview = "app_store_review"
    case versionInfo = "version_info"
    case openSource = "opensource"
}


class SettingViewController: BaseViewController {

    // MARK: - Propertys
    private let cellItems: [[SettingCellList]] = [
        [.changeFont, .changeThemeColor, .changeImageQuality],
        [.backUpAndRestore, .reset],
        [.bugReportAndFeedback, .appStoreReview],
        [.versionInfo, .openSource]
    ]
    
    private lazy var composeViewController: MFMailComposeViewController = {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients(["sin060123@gmail.com"])
        vc.setSubject("[Trip Card]")
        
        return vc
    }()
    
    
    private lazy var acknowListViewController: AcknowListViewController = {
        let vc = AcknowListViewController()
        
        guard let url = Bundle.main.url(forResource: "Package", withExtension: "resolved"),
              let data = try? Data(contentsOf: url),
              let acknowList = try? AcknowPackageDecoder().decode(from: data) else {
             return AcknowListViewController()
        }
        
        vc.acknowledgements = acknowList.acknowledgements
        
        return vc
    }()
    
    
    private let appVersion = "1.0.0"
    
    
    
    
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
        
        navigationItem.title = "setting".localized
    }
    
    
    private func resetAppData() {
        showAlert(title: "reset_alert_title".localized, buttonTitle: "reset".localized, buttonStyle: .destructive, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            
            self.showAlert(title: "reset_check_alert_title".localized, buttonTitle: "reset".localized, buttonStyle: .destructive, cancelTitle: "cancel".localized) { _ in
                do {
                    try TripDataRepository.shared.resetAppData()
                    UserDefaultManager.shared.resetAllData()
                    
                    self.changeRootViewController()
                }
                catch {
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            transition(composeViewController, transitionStyle: .present)
        }else {
            showAlert(title: "fail_send_mail_alert_title".localized, message: "fail_send_mail_alert_message".localized)
        }
    }
    
    
    private func openAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/1645004488"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }else {
            showAlert(title: "fail_connect_appstore_alert_title".localized)
        }
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
        let cell = BaseTableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row].rawValue.localized
        
        if cellItems[indexPath.section][indexPath.row] == .versionInfo {
            cell.detailTextLabel?.text = appVersion
            cell.detailTextLabel?.textColor = ColorManager.shared.textColor
            cell.detailTextLabel?.font = .customFont(size: .small)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = cellItems[indexPath.section][indexPath.row]
        
        var selectedVC: UIViewController?
        
        switch selectedCell {
        case .changeFont: selectedVC = ChangeFontViewController()
        case .changeThemeColor: selectedVC = ChangeColorViewController()
        case .changeImageQuality: selectedVC = ChangeImageQualityViewController()
        case .backUpAndRestore: selectedVC = BackupRestoreViewController()
        case .reset: resetAppData()
        case .bugReportAndFeedback: sendEmail()
        case .appStoreReview: openAppStore()
        case .versionInfo: break
        case .openSource: selectedVC = acknowListViewController
        }
        
        if let selectedVC = selectedVC {
            transition(selectedVC, transitionStyle: .push)
        }
    }
}




// MARK: - MFMail Protocol
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
