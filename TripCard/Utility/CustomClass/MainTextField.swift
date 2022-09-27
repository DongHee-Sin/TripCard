//
//  MainTextField.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import Foundation
import TextFieldEffects

final class MainTextField: HoshiTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func setupUI() {
        textColor = ColorManager.shared.textColor
        placeholderColor = .lightGray
        borderInactiveColor = .lightGray
        borderActiveColor = ColorManager.shared.buttonColor
    }
}
