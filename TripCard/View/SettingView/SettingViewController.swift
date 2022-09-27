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
    case changeFont = "폰트 변경"
    case changeThemeColor = "테마 색 변경"
    case changeImageQuality = "이미지 저장 품질 변경"
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
        [.changeFont, .changeThemeColor, .changeImageQuality],
        [.backUpAndRestore, .reset],
        [.bugReportAndFeedback, .appStoreReview],
        [.versionInfo, .openSource]
    ]
    
    private lazy var composeViewController: MFMailComposeViewController = {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients(["sin060123@gmail.com"])
        vc.setSubject("앱 제목) 개발자 문의")
        
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
        
        navigationItem.title = "설정"
    }
    
    
    private func resetAppData() {
        showAlert(title: "초기화를 진행하시겠습니까?", buttonTitle: "초기화", cancelTitle: "취소") { [weak self] _ in
            guard let self = self else { return }
            
            self.showAlert(title: "모든 카드와 이미지가 삭제됩니다. 정말 초기화를 진행할까요?", buttonTitle: "초기화", cancelTitle: "취소") { _ in
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
            showAlert(title: "메일 전송 실패", message: "디바이스의 이메일 설정을 확인하고 다시 시도해주세요.")
        }
    }
    
    
    private func openAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/1645004488"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }else {
            showAlert(title: "앱스토어 연결에 실패했습니다.")
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
        
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row].rawValue
        
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
