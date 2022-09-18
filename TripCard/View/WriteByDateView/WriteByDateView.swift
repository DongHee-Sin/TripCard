//
//  WriteView.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit
import TextFieldEffects


final class WriteByDateView: BaseView {
    
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
    
    let mainPhotoImage = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.contentMode = .scaleAspectFill
    }
    
    let addImageButton = UIButton().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        $0.tintColor = .white
        $0.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular), forImageIn: .normal)
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    let textViewPlaceHolderLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .normal)
        $0.text = "여행을 기록하세요!"
    }
    
    let contentTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: FontSize.small.rawValue)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {        
        self.addSubview(scrollView)
        
        [stackView, addImageButton].forEach {
            scrollView.addSubview($0)
        }
        
        [mainPhotoImage, textViewPlaceHolderLabel, contentTextView].forEach {
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
        
        mainPhotoImage.snp.makeConstraints { make in
            make.height.equalTo(mainPhotoImage.snp.width).multipliedBy(1.25)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(88)
            make.center.equalTo(mainPhotoImage)
        }
    }
}
