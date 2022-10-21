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


final class ChangeImageQualityDataSource: UITableViewDiffableDataSource<Int, ImageQuality> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "change_image_quality_view_header_title".localized
    }
}


final class ChangeImageQualityViewController: BaseViewController {
    
    // MARK: - Propertys
    private let currentImageQuality = ImageQuality(rawValue: UserDefaultManager.shared.imageQuality)
    
    private let imageQualityList: [ImageQuality] = [.best, .medium, .low]
    
    private var dataSource: ChangeImageQualityDataSource!
    
    
    
    
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
        
        configureDataSource()
        
        navigationItem.title = "change_image_quality".localized
    }
    
    
    private func createCellConfiguration(cell: UITableViewCell, indexPath: IndexPath) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
                
        let imageQuality = imageQualityList[indexPath.row]
        content.text = "\(imageQuality.string)"
        
        if let currentImageQuality = currentImageQuality {
            if currentImageQuality == imageQuality {
                cell.accessoryType = .checkmark
            }
        }
        
        content.textProperties.color = ColorManager.shared.textColor ?? .black
        content.textProperties.font = .customFont(size: .large)
        
        return content
    }
}




// MARK: - TableView Datasource
extension ChangeImageQualityViewController {
    
    private func configureDataSource() {
        dataSource = ChangeImageQualityDataSource(tableView: changeImageQualityView.tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            let cell = BaseTableViewCell()
            
            cell.contentConfiguration = self?.createCellConfiguration(cell: cell, indexPath: indexPath)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageQuality>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(imageQualityList)
        
        dataSource.apply(snapshot)
    }
    
}




// MARK: - TableView Delegate
extension ChangeImageQualityViewController: UITableViewDelegate {    
    
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
