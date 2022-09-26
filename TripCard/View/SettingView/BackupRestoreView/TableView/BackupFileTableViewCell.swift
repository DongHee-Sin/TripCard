//
//  BackupFileTableViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/21.
//

import UIKit

final class BackupFileTableViewCell: UITableViewCell {

    // MARK: - Propertys
    let backupImage = UIImageView().then {
        $0.tintColor = ColorManager.shared.textColor
        $0.image = UIImage(systemName: "doc.text")
    }
    
    let fileNameLabel = UILabel().then {
        $0.font = .customFont(size: .normal)
        $0.textColor = ColorManager.shared.textColor
    }
    
    let fileSizeLabel = UILabel().then {
        $0.font = .customFont(size: .small)
        $0.textColor = ColorManager.shared.textColor
    }
    
    let labelStackView = UIStackView().then {
        $0.spacing = 4
        $0.axis = .vertical
    }
    
    
    

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
        
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = ColorManager.shared.cellBackgroundColor
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methdos
    private func configureUI() {
        [fileNameLabel, fileSizeLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [backupImage, labelStackView].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = .clear
    }
    
    
    private func setConstraint() {
        backupImage.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.verticalEdges.equalToSuperview().inset(16)
            make.width.equalTo(backupImage.snp.height)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalTo(backupImage.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-8)
        }
        
    }
    
    
    func updateCell(fileName: String, fileSize: String) {
        fileNameLabel.text = fileName
        fileSizeLabel.text = fileSize
    }
}
