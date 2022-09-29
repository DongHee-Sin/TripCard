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
        
        let searchVC = SearchViewController()
        let searchNavi = BaseNavigationController(rootViewController: searchVC)
        
        let settingVC = SettingViewController()
        let settingNavi = BaseNavigationController(rootViewController: settingVC)
        
        mainVC.tabBarItem = UITabBarItem(title: "Card", image: UIImage(systemName: "square.stack"), selectedImage: UIImage(systemName: "square.stack"))
        searchNavi.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        settingNavi.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        
        setViewControllers([mainVC, searchNavi, settingNavi], animated: true)
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
