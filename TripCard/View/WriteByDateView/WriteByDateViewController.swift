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
    
    let textViewPlaceHolder = "TEST (선택)"
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        updateDataToUI()
        
        setNavigationBar()
        
        writeByDateView.addImageButton.addTarget(self, action: #selector(presentPHPickerViewController), for: .touchUpInside)
        
        phpickerViewController.delegate = self
        writeByDateView.contentTextView.delegate = self
        
        textViewDidEndEditing(writeByDateView.contentTextView)
    }
    
    
    private func updateDataToUI() {
        guard let index = index else { return }
        guard let data = viewModel?.cardByDate.value[index] else { return }
        
        writeByDateView.mainPhotoImage.image = data.photoImage
        writeByDateView.contentTextView.text = data.content
    }
    
    
    private func setNavigationBar() {
        if let index = index {
            navigationItem.title = "\(index + 1)일차 여행"
        }
    }
    
    
    private func saveData() {
        let image = writeByDateView.mainPhotoImage.image
        let content = writeByDateView.contentTextView.text ?? nil
        
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
    
    
    @objc private func presentPHPickerViewController() {
        transition(phpickerViewController, transitionStyle: .present)
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
            textView.textColor = .black
        }
    }
    

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
