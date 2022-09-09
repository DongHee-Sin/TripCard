//
//  BaseViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setNavigationBar()
        
        setInitialUI()
    }
    
    
    func configure() {}
    
    
    func setNavigationBar() {}
    
    
    private func setInitialUI() {
        view.backgroundColor = ColorManager.shared.backgroundColor
        navigationController?.navigationBar.tintColor = ColorManager.shared.buttonColor
    }
}
