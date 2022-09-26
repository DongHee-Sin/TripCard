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
            return "최고 품질"
        case .medium:
            return "중간 품질"
        case .low:
            return "저품질"
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
        
        navigationItem.title = "이미지 저장 품질 변경"
    }
}




// MARK: - TableView Protocol
extension ChangeImageQualityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "이미지 저장 품질을 선택하세요!"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageQualityList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let imageQuality = imageQualityList[indexPath.row]
        cell.textLabel?.text = "\(imageQuality.string)"
        cell.textLabel?.font = .customFont(size: .large)
        
        if let currentImageQuality = currentImageQuality {
            if currentImageQuality == imageQuality {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageQuality = imageQualityList[indexPath.row]
        
        
        if let currentImageQuality = currentImageQuality {
            if currentImageQuality == imageQuality {
                showAlert(title: "이미 적용중인 저장 품질이에요!")
                return
            }
        }
        
        
        showAlert(title: "\(imageQuality.string)(으)로 저장 품질을 변경하시겠어요?", buttonTitle: "변경하기", cancelTitle: "취소") { [weak self] _ in
            guard let self = self else { return }
            UserDefaultManager.shared.imageQuality = imageQuality.rawValue
            self.showAlert(title: "이미지 저장 품질 설정이 변경되었습니다.", message: "변경된 설정은 다음 저장 시점부터 적용됩니다.") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
