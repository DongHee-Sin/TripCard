//
//  WriteByDateViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit

import CropViewController
import TOCropViewController
import PhotosUI


final class WriteByDateViewController: BaseViewController {

    // MARK: - Propertys
    var index: Int?
    var viewModel: WriteViewModel?
    
    let textViewPlaceHolder = "card_text_view_place_holder".localized
    
    let phpickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        return pickerVC
    }()
    
    var tempImage: UIImage?
    var tempText: String?
    
    
    
    
    // MARK: - Life Cycle
    private let writeByDateView = WriteByDateView()
    override func loadView() {
        self.view = writeByDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTempData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if tempImage != writeByDateView.mainPhotoImage.image || tempText != writeByDateView.contentTextView.text {
            saveData()
        }
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        updateDataToUI()
        
        setNavigationBar()
        
        writeByDateView.addImageButton.addTarget(self, action: #selector(presentPHPickerViewController), for: .touchUpInside)
        writeByDateView.removeImageButton.addTarget(self, action: #selector(removeImageButtonTapped), for: .touchUpInside)
        writeByDateView.cropImageButton.addTarget(self, action: #selector(cropImageButtonTapped), for: .touchUpInside)
        
        phpickerViewController.delegate = self
        writeByDateView.contentTextView.delegate = self
        
        textViewDidEndEditing(writeByDateView.contentTextView)
        
        writeByDateView.tapGesture.addTarget(self, action: #selector(textViewGestureTapped))
    }
    
    
    private func setTempData() {
        tempImage = writeByDateView.mainPhotoImage.image
        tempText = writeByDateView.contentTextView.text
    }
    
    
    private func updateDataToUI() {
        guard let index = index else { return }
        guard let data = viewModel?.cardByDate.value[index] else { return }
                    
        let hidden = data.photoImage == nil
        writeByDateView.removeImageButton.isHidden = hidden
        writeByDateView.cropImageButton.isHidden = hidden
        
        writeByDateView.mainPhotoImage.image = data.photoImage
        writeByDateView.contentTextView.text = data.content
    }
    
    
    private func setNavigationBar() {
        if let index = index {
            navigationItem.title = "trip_day".localized(number: index + 1)
        }
        
        let dismissButton = UIBarButtonItem(image: UIImage.xmarkImage, style: .plain, target: self, action: #selector(dismissButtonTapped))
        let finishButton = UIBarButtonItem(title: "finish".localized, style: .plain, target: self, action: #selector(finishButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = finishButton
    }
    
    
    private func saveData() {
        let image = writeByDateView.mainPhotoImage.image
        let content = writeByDateView.contentTextView.text != textViewPlaceHolder ? writeByDateView.contentTextView.text : nil
        
        let updatedData = CardByDate(photoImage: image, content: content)
        
        guard let index = index, let viewModel = viewModel else { return }
        
        viewModel.cardByDate.value[index] = updatedData
    }
    
    
    private func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.customAspectRatio = CGSize(width: 1, height: 1.25)
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.resetButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        
        transition(cropViewController, transitionStyle: .presentOverFullScreen)
    }
    
    
    @objc private func finishButtonTapped() {
        dismiss(animated: true)
    }
    
    
    @objc private func presentPHPickerViewController() {
        transition(phpickerViewController, transitionStyle: .present)
    }
    
    
    @objc private func removeImageButtonTapped() {
        showAlert(title: "remove_image_alert_title".localized, buttonTitle: "delete".localized, buttonStyle: .destructive, cancelTitle: "cancel".localized) { [weak self] _ in
            guard let self = self else { return }
            self.writeByDateView.mainPhotoImage.image = nil
            self.writeByDateView.removeImageButton.isHidden = true
            self.writeByDateView.cropImageButton.isHidden = true
        }
    }
    
    
    @objc private func cropImageButtonTapped() {
        guard let image = writeByDateView.mainPhotoImage.image else { return }
        presentCropViewController(image: image)
    }
    
    
    @objc private func textViewGestureTapped() {
        writeByDateView.contentTextView.becomeFirstResponder()
    }
}




// MARK: - PHPicker Protocol
extension WriteByDateViewController: PHPickerViewControllerDelegate {
    
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
extension WriteByDateViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        writeByDateView.mainPhotoImage.image = image
        
        writeByDateView.removeImageButton.isHidden = false
        writeByDateView.cropImageButton.isHidden = false
        
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true)
    }
    
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true)
    }
}




// MARK: - TextView Delegate
extension WriteByDateViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = ColorManager.shared.textColor
        }
    }
    

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
