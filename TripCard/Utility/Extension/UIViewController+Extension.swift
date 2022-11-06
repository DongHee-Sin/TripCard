//
//  UIViewController+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit

import FirebaseAnalytics


extension UIViewController {
    
    // MARK: - Alert
    typealias CompletionHandler = (UIAlertAction) -> Void
    
    func showAlert(title: String, message: String? = nil, buttonTitle: String = "ok".localized, buttonStyle: UIAlertAction.Style = .default, cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    
    
    
    // MARK: - Error Alert
    func showErrorAlert(error: Error) {
        
        Analytics.logEvent("Error", parameters: [
            "error": error.localizedDescription
        ])
        
        
        if let realmError = error as? RealmError,
           let description = realmError.errorDescription {
            showAlert(title: description)
        }
        else if let codableError = error as? CodableError,
                let description = codableError.errorDescription {
            showAlert(title: description)
        }
        else if let documentError = error as? DocumentError,
                let description = documentError.errorDescription {
            showAlert(title: description)
        }
        else {
            showAlert(title: "error_occurred".localized)
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
