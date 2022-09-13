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
    
    private let floatingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        $0.tintColor = ColorManager.shared.buttonColor
    }
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabman()
        setFloatingButton()
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
    
    
    private func setFloatingButton() {
        view.addSubview(floatingButton)
        
        floatingButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func floatingButtonTapped() {
        let writeVC = WriteViewController()
        let navi = UINavigationController(rootViewController: writeVC)
        transition(navi, transitionStyle: .presentFullScreen)
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
        let item = TMBarItem(title: index == 0 ? "국내" : "해외")
        
        let imageString = index == 0 ? "location.circle" : "globe"
        item.image = UIImage(systemName: imageString)
        
        return item
    }
    
    
}
