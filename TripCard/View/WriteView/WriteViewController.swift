//
//  WriteViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit

import CropViewController
import TOCropViewController
import PanModal
import PhotosUI


final class WriteViewController: BaseViewController {

    // MARK: - Propertys
    let viewModel = WriteViewModel()
    
    let phpickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        return pickerVC
    }()
    
    
    
    
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
        
        setNavigationBarButtonItem()
        
        setNavigationBar()
        
        addCompletionToViewModelPropertys()
        
        phpickerViewController.delegate = self
    }
    
    
    private func addCompletionToViewModelPropertys() {
        viewModel.segmentValue.bind { [weak self] selectedIndex in
            guard let self = self else { return }
            self.navigationTitleImageUpdate(selectedSegmentIndex: selectedIndex)
        }
        
        viewModel.photoImage.bind { [weak self] image in
            guard let self = self else { return }
            print("header 리로드?")
            self.writeView.tableView.reloadData()
        }
    }
    
    
    private func setTableView() {
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.register(WriteTableViewCell.self, forCellReuseIdentifier: WriteTableViewCell.identifier)
        writeView.tableView.register(WriteTableViewHeader.self, forHeaderFooterViewReuseIdentifier: WriteTableViewHeader.identifier)
    }
    
    
    private func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        let addTripButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addTripButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addTripButton
    }
    
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        
        if #available(iOS 15, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        }
    }
    
    
    func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.customAspectRatio = CGSize(width: 1, height: 1.25)
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.resetButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        
        transition(cropViewController, transitionStyle: .present)
    }
    
    
    @objc private func addTripButtonTapped() {
        print("데이터 추가")
        
        let calendarVC = CalendarSheetViewController()
        if let deviceHeight = view.window?.windowScene?.screen.bounds.height {
            calendarVC.halfDeviceHeight = deviceHeight / 2
        }
        presentPanModal(calendarVC)
    }
    
    
    private func presentPHPickerViewController() {
        transition(phpickerViewController, transitionStyle: .present)
    }
    
    
    private func navigationTitleImageUpdate(selectedSegmentIndex: Int) {
        let imageText = selectedSegmentIndex == 0 ? "car" : "airplane"
        let titleImage = UIImageView(image: UIImage(systemName: imageText))
        titleImage.tintColor = ColorManager.shared.buttonColor
        
        navigationItem.titleView = titleImage
    }
}




// MARK: - TableView Protocol
extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WriteTableViewHeader.identifier) as? WriteTableViewHeader else {
            return nil
        }
        
        header.delegate = self
        header.updateCell(viewModel: viewModel)
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteTableViewCell.identifier, for: indexPath) as? WriteTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let writeByDateVC = WriteByDateViewController()
        transition(writeByDateVC, transitionStyle: .present)
    }
}




// MARK: - PHPicker Protocol
extension WriteViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                guard let selectedImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.presentCropViewController(image: selectedImage)
                }
            }
        }
        
        self.dismiss(animated: true)
    }
}




// MARK: - CropViewController Protocol
extension WriteViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        viewModel.photoImage.value = image
        self.dismiss(animated: true)
    }
}




// MARK: - Writing Delegate Protocol
extension WriteViewController: WritingDelegate {
    func addImageButtonTapped() {
        presentPHPickerViewController()
    }
    
    
    func segmentValueChanged(_ index: Int) {
        viewModel.segmentValue.value = index
    }
}
