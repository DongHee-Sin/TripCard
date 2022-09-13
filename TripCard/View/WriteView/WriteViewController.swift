//
//  WriteViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit
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
        
        dismissKeyboardWhenTappedAround()
        
        writeView.addImageButton.addTarget(self, action: #selector(presentPHPickerViewController), for: .touchUpInside)
    }
    
    
    func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        let addTripButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addTripButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addTripButton
    }
    
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
}




extension WriteViewController: PHPickerViewControllerDelegate {
    
    // PHPicker6. 필수 메서드 구현 (선택이 완료되면 호출)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                guard let selectedImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.writeView.photoImage.image = selectedImage
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
}
