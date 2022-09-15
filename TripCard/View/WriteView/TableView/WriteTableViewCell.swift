//
//  WriteTableViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit

final class WriteTableViewCell: UITableViewCell {

    // MARK: - Propertys
    let dateLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.textColor = .white
        $0.backgroundColor = ColorManager.shared.buttonColor
        $0.font = .customFont(size: .normal)
        
        $0.text = "  n일차  "
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: FontSize.small.rawValue)
        
        $0.text = "TEST TEST TEST TEST TEST"
    }
    
    let photoImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray6
        $0.contentMode = .scaleAspectFill
        
        $0.image = UIImage(systemName: "photo.circle")
    }
    
    
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
        
        self.selectionStyle = .none
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methdos
    private func configureUI() {
        [dateLabel, contentLabel, photoImage].forEach {
            self.addSubview($0)
        }
    }
    
    
    private func setConstraint() {
        photoImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.width.equalTo(photoImage.snp.height)
        }
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.verticalEdges.equalTo(self).inset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
            make.trailing.equalTo(photoImage.snp.leading).offset(-12)
            make.verticalEdges.equalTo(self).inset(8)
        }
    }
    
    
//    func updateCell(viewModel: WriteViewModel) {
//
//    }

}
