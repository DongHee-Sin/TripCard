//
//  TabBarViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/12.
//

import UIKit


class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainViewController()
        
        mainVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "globe.asia.australia"), selectedImage: UIImage(systemName: "globe.asia.australia.fill"))
        
        setViewControllers([mainVC], animated: true)
    }
    
}
