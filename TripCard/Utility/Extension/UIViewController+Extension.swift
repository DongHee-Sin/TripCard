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
    
    func showAlert(title: String, buttonTitle: String = "확인", cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .destructive)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    
    
    
    // MARK: - Error Alert
    func showErrorAlert(error: Error) {
        switch error {
        case RealmError.writeError: showAlert(title: "메모 저장에 실패했습니다.")
        case RealmError.updateError: showAlert(title: "메모 수정에 실패했습니다.")
        case RealmError.deleteError: showAlert(title: "메모 삭제에 실패했습니다.")
        case DocumentError.createDirectoryError: showAlert(title: "저장 폴더 생성에 실패했습니다.")
        case DocumentError.saveImageError: showAlert(title: "이미지 저장에 실패했습니다.")
        case DocumentError.removeDirectoryError: showAlert(title: "저장 폴더 삭제에 실패했습니다.")
        case DocumentError.fetchImagesError: showAlert(title: "이미지를 가져오는데 실패했습니다.")
        case DocumentError.fetchZipFileError: showAlert(title: "압축 파일을 가져오는데 실패했습니다.")
        case DocumentError.fetchDirectoryPathError: showAlert(title: "폴더 경로를 가져오는데 실패했습니다.")
        case DocumentError.compressionFailedError: showAlert(title: "파일 압축에 실패했습니다.")
        case DocumentError.restoreFailedError: showAlert(title: "파일 복구에 실패했습니다.")
        case DocumentError.fetchJsonDataError: showAlert(title: "JSON 파일을 가져오는데 실패했습니다.")
        case CodableError.jsonDecodeError: showAlert(title: "데이터 디코딩에 실패했습니다.")
        case CodableError.jsonEncodeError: showAlert(title: "데이터 인코딩에 실패했습니다.")
        default: showAlert(title: "에러가 발생했습니다.")
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
