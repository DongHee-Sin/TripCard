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
        let settingNavi = BaseNavigationController(rootViewController: settingVC)
        
        mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "airplane"), selectedImage: UIImage(systemName: "airplane"))
        settingNavi.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        setViewControllers([mainVC, settingNavi], animated: true)
    }
    
    private func setTabBarUI() {
        let appearence = UITabBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = ColorManager.shared.selectedColor
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
        tabBar.tintColor = ColorManager.shared.textColor
    }
}
