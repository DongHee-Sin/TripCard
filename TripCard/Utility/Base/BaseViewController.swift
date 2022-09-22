//
//  BaseViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit
import JGProgressHUD


class BaseViewController: UIViewController {

    // MARK: - Propertys
    lazy var hud = JGProgressHUD(style: .dark)
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        setInitialUI()
    }
    
    
    
    
    // MARK: - Methods
    func configure() {}
    
    
    private final func setInitialUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
    }
    
    
    final func showIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.show(in: self.view, animated: true)
        }
    }
    
    
    final func dismissIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.dismiss(animated: true)
        }
    }
}
