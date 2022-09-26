//
//  BaseTableViewCell.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/27.
//

import UIKit

final class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func configureUI() {
        backgroundColor = ColorManager.shared.cellBackgroundColor
        textLabel?.font = .customFont(size: .large)
        textLabel?.textColor = ColorManager.shared.textColor
        selectionStyle = .none
    }
}
