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
    
    private let addImageFloatingButton = UIButton().then {
        $0.layer.cornerRadius = 44
        $0.tintColor = ColorManager.shared.buttonColor
        $0.backgroundColor = .white
        $0.setPreferredSymbolConfiguration(.init(pointSize: 44, weight: .regular), forImageIn: .normal)
        $0.setImage(UIImage(systemName: "photo.circle.fill"), for: .normal)
    }

    let locationTextField = MainTextField().then {
        $0.tag = 0
        $0.placeholder = "location_place_holder".localized
    }

    let periodTextField = MainTextField().then {
        $0.tag = 1
        $0.placeholder = "period_place_holder".localized
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
        [stackView, addImageButton, addImageFloatingButton].forEach {
            self.addSubview($0)
        }
        
        [mainPhotoImage, segmentControl, locationTextField, periodTextField].forEach {
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
        
        addImageFloatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(mainPhotoImage.snp.trailing).offset(-10)
            make.bottom.equalTo(mainPhotoImage.snp.bottom).offset(-10)
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
        addImageFloatingButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    
    @objc private func addImageButtonTapped() {
        delegate?.addImageButtonTapped()
    }
    
    
    @objc private func segmentValueChanged(_ segmentControl: UISegmentedControl) {
        delegate?.segmentValueChanged(segmentControl.selectedSegmentIndex)
    }
    
    
    func updateHeader(viewModel: WriteViewModel) {
        let isImageExist: Bool = viewModel.mainPhotoImage.value != nil
        addImageButton.isHidden = isImageExist
        addImageFloatingButton.isHidden = !isImageExist
        
        mainPhotoImage.image = viewModel.mainPhotoImage.value
        segmentControl.selectedSegmentIndex = viewModel.segmentValue.value
        locationTextField.text = viewModel.location.value
        periodTextField.text = viewModel.periodString
    }
}
