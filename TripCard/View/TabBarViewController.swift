//
//  TabBarViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import UIKit


final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()
        setTabBarUI()
    }
    
    
    private func setViewControllers() {
        let mainVC = MainViewController()
        let settingVC = SettingViewController()
        
        mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane"))
        settingVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        setViewControllers([mainVC, settingVC], animated: true)
    }
    
    private func setTabBarUI() {
        tabBar.barTintColor = ColorManager.shared.selectedColor
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    }
}
