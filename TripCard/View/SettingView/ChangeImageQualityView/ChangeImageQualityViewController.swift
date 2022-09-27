//
//  ChangeImageQualityViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/26.
//

import UIKit


enum ImageQuality: Double {
    case best = 0.5
    case medium = 0.3
    case low = 0.1
    
    var string: String {
        switch self {
        case .best:
            return "image_quality_best".localized
        case .medium:
            return "image_quality_medium".localized
        case .low:
            return "image_quality_low".localized
        }
    }
}


final class ChangeImageQualityViewController: BaseViewController {
    
    // MARK: - Propertys
    private let currentImageQuality = ImageQuality(rawValue: UserDefaultManager.shared.imageQuality)
    
    private let imageQualityList: [ImageQuality] = [.best, .medium, .low]
    
    
    
    
    // MARK: - Life Cycle
    private let changeImageQualityView = ReusableTableCustomView()
    override func loadView() {
        self.view = changeImageQualityView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        changeImageQualityView.tableView.delegate = self
        changeImageQualityView.tableView.dataSource = self
        
        navigationItem.title = "change_image_quality".localized
    }
}




// MARK: - TableView Protocol
extension ChangeImageQualityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_image_quality_view_header_title".localized
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageQualityList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell()
        
        let imageQuality = imageQualityList[indexPath.row]
        cell.textLabel?.text = "\(imageQuality.string)"
        
        if let currentImageQuality = currentImageQuality {
            if currentImageQuality == imageQuality {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageQuality = imageQualityList[indexPath.row]
        
        
        if let currentImageQuality = currentImageQuality {
            if currentImageQuality == imageQuality {
                showAlert(title: "already_applied_image_quality_alert_title".localized)
                return
            }
        }
        
        
        showAlert(title: "change_image_quality_alert_title".localized(with: imageQuality.string), buttonTitle: "change".localized, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            UserDefaultManager.shared.imageQuality = imageQuality.rawValue
            self.showAlert(title: "image_quality_changed_alert_title".localized, message: "image_quality_changed_alert_message".localized) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
