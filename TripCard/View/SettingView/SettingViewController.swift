//
//  SettingViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit
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


final class SettingViewController: BaseViewController {

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
    
    private var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        
        return version
    }
    
    private var dataSource: UITableViewDiffableDataSource<Int, SettingCellList>!
    
    
    
    
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
        configureDataSource()
        
        settingView.tableView.delegate = self
        
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
    
    
    private func createCellConfiguration(cell: UITableViewCell, indexPath: IndexPath) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        
        content.text = cellItems[indexPath.section][indexPath.row].rawValue.localized
        content.textProperties.color = ColorManager.shared.textColor ?? .black
        content.textProperties.font = .customFont(size: .large)
        
        if cellItems[indexPath.section][indexPath.row] == .versionInfo {
            content.secondaryText = appVersion
            content.secondaryTextProperties.color = ColorManager.shared.textColor ?? .black
            content.secondaryTextProperties.font = .customFont(size: .small)
            content.prefersSideBySideTextAndSecondaryText = true
        }
        
        return content
    }
}




// MARK: - TableView Datasource
extension SettingViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: settingView.tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            let cell = BaseTableViewCell()
            cell.contentConfiguration = self?.createCellConfiguration(cell: cell, indexPath: indexPath)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, SettingCellList>()
        
        let sections = [0, 1, 2, 3]
        
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(cellItems[section], toSection: section)
        }
        
        dataSource.apply(snapshot)
    }
    
}




// MARK: - TableView Delegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
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
        case .openSource: selectedVC = OpenSourceListViewController()
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
