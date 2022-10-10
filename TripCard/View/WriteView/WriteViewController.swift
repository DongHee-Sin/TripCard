//
//  WriteViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit

import CropViewController
import TOCropViewController
import PhotosUI


enum PHPickerStatus {
    case mainImage
    case imageByDate
}


final class WriteViewController: BaseViewController {

    // MARK: - Propertys
    private let viewModel = WriteViewModel()
    
    lazy private var calendarViewController: CalendarSheetViewController = {
        let calendarVC = CalendarSheetViewController()
        
        if let deviceHeight = view.window?.windowScene?.screen.bounds.height {
            calendarVC.halfDeviceHeight = deviceHeight / 2
        }
        
        calendarVC.delegate = self
        
        return calendarVC
    }()
    
    var modifyCardCompletion: (() -> Void)?
    
    private var startDateBeforeChange: Date?
    
    private var periodBindToggle = false
    
    private var phpickerStatus: PHPickerStatus = .mainImage
    
    
    
    
    // MARK: - Life Cycle
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setTableView()
        
        addCompletionToViewModelPropertys()
        
        setNavigationBarButtonItem()
    }
    
    
    private func setTableView() {
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.register(WriteTableViewCell.self, forCellReuseIdentifier: WriteTableViewCell.identifier)
        writeView.tableView.register(WriteTableViewHeader.self, forHeaderFooterViewReuseIdentifier: WriteTableViewHeader.identifier)
    }
    
    
    private func addCompletionToViewModelPropertys() {
        viewModel.mainPhotoImage.bind { [weak self] image in
            guard let self = self else { return }
            self.writeView.tableView.reloadSections(IndexSet(0...0), with: .none)
        }
        
        
        viewModel.segmentValue.bind { [weak self] selectedIndex in
            guard let self = self else { return }
            self.updateNavigationTitleImage(selectedSegmentIndex: selectedIndex)
        }
        
        
        viewModel.location.bind { [weak self] location in
            guard let self = self else { return }
            self.writeView.tableView.reloadSections(IndexSet(0...0), with: .none)
        }
        
        
        viewModel.tripPeriod.bind { [weak self] dates in
            guard let self = self else { return }
            
            guard self.periodBindToggle else {     // 수정 상태로 화면 처음 진입 시 날짜별 카드 데이터 삭제되는 것 방지
                self.periodBindToggle.toggle()
                return
            }
            
            if self.viewModel.numberOfCell > 0 {
                // Calendar를 띄울 때, 기간 데이터가 입력되어 있었는지 여부
                guard let startDateBeforeChange = self.startDateBeforeChange else {
                    self.viewModel.cardByDate.value = Array(repeating: CardByDate(), count: self.viewModel.numberOfCell)
                    return
                }
                
                // 기존 데이터를 [날짜: 데이터] Dictionary 형태로 변환
                var cardByDateBeforeChange: [Date: CardByDate] = [:]
                self.viewModel.cardByDate.value.enumerated().forEach { (index, cardByDate) in
                    let date = startDateBeforeChange.add(day: index)
                    cardByDateBeforeChange[date] = cardByDate
                }
                
                // 새로 등록할 데이터 배열
                var cardByDate: [CardByDate] = []
                for index in 0..<self.viewModel.numberOfCell {
                    let date = self.viewModel.tripPeriod.value!.start.add(day: index)
                    cardByDate.append(cardByDateBeforeChange[date] ?? CardByDate())
                }
                
                self.viewModel.cardByDate.value = cardByDate
            }else {
                // 기간이 입력되지 않았다면 빈 배열로 설정 (Cell 생성 X)
                self.viewModel.cardByDate.value = []
            }
        }
        
        
        viewModel.cardByDate.bind { [weak self] _ in
            guard let self = self else { return }
            
            self.writeView.tableView.reloadData()
        }
    }
    
    
    private func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage.xmarkImage, style: .plain, target: self, action: #selector(dismissButtonTapped))
        let addTripButton = UIBarButtonItem(title: "finish".localized, style: .plain, target: self, action: #selector(finishButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addTripButton
    }
    
    
    private func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.customAspectRatio = CGSize(width: 1, height: 1.25)
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.resetButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        
        self.dismissIndicator()
        
        transition(cropViewController, transitionStyle: .present)
    }
    
    
    @objc private func finishButtonTapped() {
        
        switch viewModel.writeViewStatus {
        case .needEnterLocationData: showAlert(title: "location_is_required".localized)
        case .needEnterPeriodData: showAlert(title: "period_is_required".localized)
        case .dataCanBeStored:
            do {
                try viewModel.finishButtonTapped()
            }
            catch {
                showErrorAlert(error: error)
            }
            
            if viewModel.writeCardMode == .modify {
                modifyCardCompletion?()
            }
            
            dismiss(animated: true)
        }
    }
    
    
    @objc override func dismissButtonTapped() {
        if viewModel.isDataEntered {
            showAlert(title: "write_view_dismiss_title".localized, message: "write_view_dismiss_message".localized, buttonTitle: "dismiss".localized, cancelTitle: "cancel".localized) { _ in
                super.dismissButtonTapped()
            }
        }else {
            super.dismissButtonTapped()
        }
    }
    
    
    private func presentPHPickerViewController(selectionLimit: Int? = nil) {
        
        let phpickerViewController: PHPickerViewController = {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = selectionLimit ?? 1
            configuration.filter = .images
            
            let pickerVC = PHPickerViewController(configuration: configuration)
            pickerVC.delegate = self
            
            return pickerVC
        }()
        
        phpickerStatus = selectionLimit == nil ? .mainImage : .imageByDate
        
        transition(phpickerViewController, transitionStyle: .present)
    }
    
    
    private func updateNavigationTitleImage(selectedSegmentIndex: Int) {
        let imageText = selectedSegmentIndex == 0 ? "car" : "airplane"
        let titleImage = UIImageView(image: UIImage(systemName: imageText))
        titleImage.tintColor = ColorManager.shared.buttonColor
        
        navigationItem.titleView = titleImage
    }
    
    
    func updateViewModel(mainImage: UIImage?, imageByDate: [UIImage?], trip: Trip) {
        viewModel.mainPhotoImage.value = mainImage
        viewModel.forModifyTrip = trip
        
        viewModel.writeCardMode = .modify
        
        let cardByDate = zip(imageByDate, trip.contentByDate).map { (image, content) in
            return CardByDate(photoImage: image, content: content)
        }
        viewModel.cardByDate.value = cardByDate
    }
}




// MARK: - TableView Protocol
extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : .zero
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WriteTableViewHeader.identifier) as? WriteTableViewHeader else {
            return nil
        }
        header.delegate = self
        header.updateHeader(viewModel: viewModel)
        
        header.locationTextField.delegate = self
        header.periodTextField.delegate = self
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : viewModel.numberOfCell
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section != 0 else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteTableViewCell.identifier, for: indexPath) as? WriteTableViewCell else {
            return UITableViewCell()
        }
        
        let cardByDate = viewModel.cardByDate.value[indexPath.row]
        cell.updateCell(index: indexPath.row, date: viewModel.tripPeriod.value?.start, cardByDate: cardByDate)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? .zero : 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        
        let writeByDateVC = WriteByDateViewController()
        
        writeByDateVC.index = indexPath.row
        writeByDateVC.viewModel = viewModel
        
        let navi = BaseNavigationController(rootViewController: writeByDateVC)
        
        transition(navi, transitionStyle: .present)
    }
}




// MARK: - PHPicker Protocol
extension WriteViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        switch phpickerStatus {
        case .mainImage:
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    guard let selectedImage = image as? UIImage else { return }
                    
                    self.showIndicator()
                    
                    DispatchQueue.main.async {
                        self.presentCropViewController(image: selectedImage)
                    }
                }
            }
        case .imageByDate:
            showIndicator()
            
            let itemProviders = results.map { $0.itemProvider }
            
            var temp = viewModel.cardByDate.value
            
            let group = DispatchGroup()
            
            itemProviders.enumerated().forEach { index, provider in
                group.enter()
                
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let selectedImage = image as? UIImage else {
                        group.leave()
                        return
                    }
                    
                    temp[index].photoImage = selectedImage
                    group.leave()
                }
            }
            
            group.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.viewModel.cardByDate.value = temp
                self.dismissIndicator()
            }
        }
        
        self.dismiss(animated: true)
    }
}




// MARK: - CropViewController Protocol
extension WriteViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        viewModel.mainPhotoImage.value = image
        self.dismiss(animated: true)
    }
}




// MARK: - Writing Delegate Protocol
extension WriteViewController: WritingDelegate {
    func addImageButtonTapped() {
        presentPHPickerViewController()
    }
    
    
    func addImageByDateButtonTapped() {
        presentPHPickerViewController(selectionLimit: viewModel.cardByDate.value.count)
    }
    
    
    func removeImageButtonTapped() {
        showAlert(title: "remove_image_alert_title".localized, buttonTitle: "delete".localized, buttonStyle: .destructive, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.mainPhotoImage.value = nil
        }
    }
    
    
    func cropImageButtonTapped() {
        guard let image = viewModel.mainPhotoImage.value else { return }
        presentCropViewController(image: image)
    }
    
    
    func segmentValueChanged(_ index: Int) {
        viewModel.segmentValue.value = index
    }
}




// MARK: - TextField Delegate
extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {        
        if textField.tag == 0 {
            let locationSearchVC = LocationSearchViewController()
            locationSearchVC.delegate = self
            
            transition(locationSearchVC, transitionStyle: .present)
            
        }
        else if textField.tag == 1 {
            if !viewModel.cardByDate.value.isEmpty {
                showAlert(title: "edit_period_alert_title".localized, message: "edit_period_alert_message".localized, buttonTitle: "edit_period".localized, cancelTitle: "cancel".localized) { [weak self] _ in
                    guard let self = self else { return }
                    self.presentCalendarViewController()
                }
                
                return false
            }
            
            presentCalendarViewController()
            
        }
        
        return false
    }
    
    
    private func presentCalendarViewController() {
        calendarViewController.calendarInitialSetting(viewModel: viewModel)
        
        if let sheet = calendarViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        startDateBeforeChange = viewModel.tripPeriod.value?.start
        
        transition(calendarViewController, transitionStyle: .present)
    }
}




// MARK: - Add Period Delegate
extension WriteViewController: AddPeriodDelegate {
    func addPeriod(period: TripPeriod?) {
        viewModel.tripPeriod.value = period
    }
}




// MARK: - Add Location Delegate
extension WriteViewController: AddLocationDelegate {
    func addLocation(location: String) {
        viewModel.location.value = location
    }
}
