//
//  BaseNavigationController+Extension.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/18.
//

import UIKit


final class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setNavigationBar()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setNavigationBar() {
        self.navigationBar.tintColor = ColorManager.shared.textColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(size: .large)]
    }
}
