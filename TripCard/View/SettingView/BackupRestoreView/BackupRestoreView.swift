//
//  BackupRestoreView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/21.
//

import UIKit


final class BackupRestoreView: BaseView {
    
    // MARK: - Propertys
    let backupLabel = UILabel().then {
        $0.text = "백업하기"
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .largest)
    }
    
    let backupDescriptionLabel = UILabel().then {
        $0.text = """
        생성된 백업 파일은 앱 내에 생성되기 때문에, 앱이 삭제되면 백업 파일도 삭제됩니다.
        메신저, 이메일, 클라우드 저장소 등을 활용하여 백업 파일을 별도 관리하는 것을 권장합니다.
        """
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
    }
    
    lazy var createBackupFileButton = UIButton().then {
        $0.configuration = setButtonConfiguration(title: "백업 파일 생성하기")
    }
    
    lazy var fetchBackupFileButton = UIButton().then {
        $0.configuration = setButtonConfiguration(title: "백업 파일 가져오기")
    }
    
    let backupFileTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [backupLabel, backupDescriptionLabel, createBackupFileButton, fetchBackupFileButton, backupFileTableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        backupLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        backupDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backupLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        createBackupFileButton.snp.makeConstraints { make in
            make.top.equalTo(backupDescriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        fetchBackupFileButton.snp.makeConstraints { make in
            make.top.equalTo(createBackupFileButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        backupFileTableView.snp.makeConstraints { make in
            make.top.equalTo(fetchBackupFileButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
    private func setButtonConfiguration(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .customFont(size: .normal)
            return outgoing
        })
        config.baseBackgroundColor = ColorManager.shared.selectedColor
        config.baseForegroundColor = ColorManager.shared.textColor
        
        return config
    }
}
