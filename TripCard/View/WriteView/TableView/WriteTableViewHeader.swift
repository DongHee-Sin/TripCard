//
//  WriteTableViewHeader.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit
import SnapKit


protocol WritingDelegate: AnyObject {
    func addImageButtonTapped()
    
    func addImageByDateButtonTapped()
    
    func removeImageButtonTapped()
    
    func segmentValueChanged(_ index: Int)
}


final class WriteTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Propertys
    weak var delegate: WritingDelegate?
    
    
    private let stackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 16
        $0.axis = .vertical
    }

    private let mainPhotoImage = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.contentMode = .scaleAspectFill
    }

    private let segmentControl = UISegmentedControl(items: ["domestic_trip".localized, "overseas_trip".localized]).then {
        $0.setTitleTextAttributes([.foregroundColor: ColorManager.shared.textColor], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        $0.selectedSegmentTintColor = ColorManager.shared.selectedColor
        $0.backgroundColor = .lightGray
    }

    private let addImageButton = UIButton().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        $0.tintColor = .white
        $0.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular), forImageIn: .normal)
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    private let removeImageButton = UIButton().then {
        $0.tintColor = UIColor(hex: "F96666ff")
        $0.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular), forImageIn: .normal)
        $0.setImage(UIImage(systemName: "trash.circle"), for: .normal)
    }

    let locationTextField = MainTextField().then {
        $0.tag = 0
        $0.placeholder = "location_place_holder".localized
    }

    let periodTextField = MainTextField().then {
        $0.tag = 1
        $0.placeholder = "period_place_holder".localized
    }
    
    
    let addImageByDateButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.title = "이미지 한번에 등록하기"
        config.baseBackgroundColor = ColorManager.shared.selectedColor
        config.baseForegroundColor = ColorManager.shared.textColor
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        // font 설정
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .customFont(size: .normal)
            return outgoing
        })
        
        $0.configuration = config
    }
    
    
    
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
        addTarget()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methods
    private func configureUI() {
        [stackView, addImageButton, removeImageButton].forEach {
            self.addSubview($0)
        }
        
        [mainPhotoImage, segmentControl, locationTextField, periodTextField, addImageByDateButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    
    private func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(0)
        }
        
        mainPhotoImage.snp.makeConstraints { make in
            make.height.equalTo(mainPhotoImage.snp.width).multipliedBy(1.25)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(88)
            make.center.equalTo(mainPhotoImage)
        }
        
        removeImageButton.snp.makeConstraints { make in
            make.leading.equalTo(mainPhotoImage.snp.leading).offset(10)
            make.top.equalTo(mainPhotoImage.snp.top).offset(10)
        }
        
        locationTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        periodTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    
    private func addTarget() {
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        addImageByDateButton.addTarget(self, action: #selector(addImageByDateButtonTapped), for: .touchUpInside)
        
        removeImageButton.addTarget(self, action: #selector(removeImageButtonTapped), for: .touchUpInside)
        
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    
    @objc private func addImageButtonTapped() {
        delegate?.addImageButtonTapped()
    }
    
    
    @objc private func addImageByDateButtonTapped() {
        delegate?.addImageByDateButtonTapped()
    }
    
    
    @objc private func removeImageButtonTapped() {
        delegate?.removeImageButtonTapped()
    }
    
    
    @objc private func segmentValueChanged(_ segmentControl: UISegmentedControl) {
        delegate?.segmentValueChanged(segmentControl.selectedSegmentIndex)
    }
    
    
    func updateHeader(viewModel: WriteViewModel) {
        removeImageButton.isHidden = viewModel.mainPhotoImage.value == nil
        
        addImageByDateButton.isHidden = viewModel.periodString == ""
        
        mainPhotoImage.image = viewModel.mainPhotoImage.value
        segmentControl.selectedSegmentIndex = viewModel.segmentValue.value
        locationTextField.text = viewModel.location.value
        periodTextField.text = viewModel.periodString
    }
}
