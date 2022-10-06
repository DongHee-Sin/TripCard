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
    
    
    
    
    // MARK: - Life Cycle
    let writeByDateView = WriteByDateView()
    override func loadView() {
        self.view = writeByDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        saveData()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        updateDataToUI()
        
        setNavigationBar()
        
        writeByDateView.addImageButton.addTarget(self, action: #selector(presentPHPickerViewController), for: .touchUpInside)
        writeByDateView.removeImageButton.addTarget(self, action: #selector(removeImageButtonTapped), for: .touchUpInside)
        
        phpickerViewController.delegate = self
        writeByDateView.contentTextView.delegate = self
        
        textViewDidEndEditing(writeByDateView.contentTextView)
        
        writeByDateView.tapGesture.addTarget(self, action: #selector(textViewGestureTapped))
    }
    
    
    private func updateDataToUI() {
        guard let index = index else { return }
        guard let data = viewModel?.cardByDate.value[index] else { return }
                    
        writeByDateView.removeImageButton.isHidden = data.photoImage == nil
        
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
        
        transition(cropViewController, transitionStyle: .present)
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
        }
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
