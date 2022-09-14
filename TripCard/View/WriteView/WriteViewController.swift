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


final class WriteViewController: BaseViewController {

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
        setNavigationBarButtonItem()
        
        setNavigationBar()
        
        dismissKeyboardWhenTappedAround()
        
        writeView.addImageButton.addTarget(self, action: #selector(presentPHPickerViewController), for: .touchUpInside)
        
        writeView.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    }
    
    
    func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        let addTripButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addTripButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addTripButton
    }
    
    
    func setNavigationBar() {
        navigationTitleImageUpdate(selectedSegmentIndex: writeView.segmentControl.selectedSegmentIndex)
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
    }
    
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    @objc private func presentPHPickerViewController() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerVC = PHPickerViewController(configuration: configuration)
        pickerVC.delegate = self
        
        transition(pickerVC, transitionStyle: .present)
    }
    
    
    @objc func segmentControlValueChanged(_ segment: UISegmentedControl) {
        navigationTitleImageUpdate(selectedSegmentIndex: segment.selectedSegmentIndex)
    }
    
    
    private func navigationTitleImageUpdate(selectedSegmentIndex: Int) {
        let imageText = selectedSegmentIndex == 0 ? "car" : "airplane"
        let titleImage = UIImageView(image: UIImage(systemName: imageText))
        
        navigationItem.titleView = titleImage
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
        self.writeView.mainPhotoImage.image = image
        self.dismiss(animated: true)
    }
}
