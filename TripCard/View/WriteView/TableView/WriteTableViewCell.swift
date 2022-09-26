//
//  WriteTableViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit

final class WriteTableViewCell: UITableViewCell {

    // MARK: - Propertys
    let dateCountLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.textColor = .white
        $0.backgroundColor = ColorManager.shared.buttonColor
        $0.font = .customFont(size: .normal)
    }
    
    let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: FontSize.small.rawValue)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: FontSize.smaller.rawValue)
    }
    
    let labelStackView = UIStackView().then {
        $0.distribution = .fillProportionally
//        $0.spacing =
        $0.axis = .vertical
    }
    
    let photoImage = UIImageView().then {
        $0.tintColor = ColorManager.shared.buttonColor
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
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
        [contentLabel, dateLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [dateCountLabel, labelStackView, photoImage].forEach {
            self.addSubview($0)
        }
    }
    
    
    private func setConstraint() {
        photoImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.width.equalTo(photoImage.snp.height)
        }
        
        dateCountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        dateCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.verticalEdges.equalTo(self).inset(8)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(dateCountLabel.snp.trailing).offset(12)
            make.trailing.equalTo(photoImage.snp.leading).offset(-12)
            make.verticalEdges.equalTo(self).inset(8)
        }
    }
    
    
    func updateCell(index: Int, date: Date?, cardByDate: CardByDate) {
        dateCountLabel.text = "  \(index + 1)일차  "
        contentLabel.text = cardByDate.content
        dateLabel.text = date?.add(day: index).string
        photoImage.image = cardByDate.photoImage ?? UIImage(systemName: "photo.circle")
    }

}
