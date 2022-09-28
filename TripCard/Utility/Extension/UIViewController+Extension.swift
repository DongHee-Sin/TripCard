//
//  UIViewController+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit


extension UIViewController {
    
    // MARK: - Alert
    typealias CompletionHandler = (UIAlertAction) -> Void
    
    func showAlert(title: String, message: String? = nil, buttonTitle: String = "확인", cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    
    
    
    // MARK: - Error Alert
    func showErrorAlert(error: Error) {
        switch error {
        case RealmError.writeError: showAlert(title: "create_card_date_error".localized)
        case RealmError.updateError: showAlert(title: "modify_card_date_error".localized)
        case RealmError.deleteError: showAlert(title: "delete_card_date_error".localized)
        case DocumentError.createDirectoryError: showAlert(title: "create_directory_error".localized)
        case DocumentError.saveImageError: showAlert(title: "save_image_error".localized)
        case DocumentError.removeFileError: showAlert(title: "delete_file_error".localized)
        case DocumentError.removeDirectoryError: showAlert(title: "delete_directory_error".localized)
        case DocumentError.fetchImagesError: showAlert(title: "fetch_image_error".localized)
        case DocumentError.fetchZipFileError: showAlert(title: "fetch_zip_file_error".localized)
        case DocumentError.fetchDirectoryPathError: showAlert(title: "fetch_directory_path_error".localized)
        case DocumentError.compressionFailedError: showAlert(title: "compression_file_error".localized)
        case DocumentError.restoreFailedError: showAlert(title: "restore_file_error".localized)
        case DocumentError.fetchJsonDataError: showAlert(title: "fetch_json_file_error".localized)
        case CodableError.jsonDecodeError: showAlert(title: "json_decode_error".localized)
        case CodableError.jsonEncodeError: showAlert(title: "json_encode_error".localized)
        case CodableError.noDataToBackupError: showAlert(title: "no_data_to_backup".localized)
        default: showAlert(title: "error_occurred".localized)
        }
    }
    

    
    
    // MARK: - Transition ViewController
    enum TransitionStyle {
        case present
        case presentFullScreen
        case presentOverFullScreen
        case push
    }
    
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentFullScreen:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        case .presentOverFullScreen:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    
    
    
    // MARK: - dismiss method
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    
    
    
    // MARK: - Root View Controller
    func changeRootViewController(to rootVC: UIViewController = TabBarViewController()) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
