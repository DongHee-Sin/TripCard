//
//  MainViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit

import Tabman
import Pageboy


final class MainViewController: TabmanViewController {
    
    // MARK: - Propertys
    private var viewControllers: [UIViewController] = []
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabman()
    }
    
    
    
    
    // MARK: - Methods
    private func configureTabman() {
        viewControllers.append(DomesticListViewController())
        viewControllers.append(OverseasListViewController())
        
        self.dataSource = self
        
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .snap
        bar.buttons.customize {
            $0.tintColor = .black
            $0.selectedTintColor = ColorManager.shared.buttonColor
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    
    @objc private func settingButtonTapped() {
        print("설정 화면으로 이동")
    }
}




// MARK: - Tabman Protocol
extension MainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = index == 0 ? "국내" : "해외"
        
        let imageString = index == 0 ? "location.circle" : "globe.asia.australia"
        item.image = UIImage(systemName: imageString)
        
        return item
    }
    
    
}
