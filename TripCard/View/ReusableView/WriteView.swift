//
//  WriteView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit
import TextFieldEffects


final class WriteView: BaseView {
    
    // MARK: - Propertys
    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
    }
    
    let stackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 16
        $0.axis = .vertical
    }
    
    let photoImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
    }
    
    let addImageButton = UIButton().then {
        $0.tintColor = ColorManager.shared.buttonColor
        $0.setImage(UIImage(systemName: "photo"), for: .normal)
    }
    
    let locationTextField = MainTextField().then {
        $0.placeholder = "지역"
    }
    
    let periodTextField = MainTextField().then {
        $0.placeholder = "기간"
    }
    
    let contentTextView = UITextView().then {
        $0.font = .systemFont(ofSize: FontSize.small.rawValue)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {        
        self.addSubview(scrollView)
        
        [stackView, addImageButton].forEach {
            scrollView.addSubview($0)
        }
        
        [photoImage, locationTextField, periodTextField, contentTextView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    
    override func setConstraint() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(0)
            make.width.equalTo(scrollView.snp.width)
        }
        
        photoImage.snp.makeConstraints { make in
            make.height.equalTo(photoImage.snp.width).multipliedBy(1.25)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.trailing.equalTo(photoImage.snp.trailing).offset(-30)
            make.bottom.equalTo(photoImage.snp.bottom).offset(-30)
        }
        
        locationTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        periodTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
    }
}
