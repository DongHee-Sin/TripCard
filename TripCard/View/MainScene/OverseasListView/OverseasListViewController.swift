//
//  OverseasListViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit

final class OverseasListViewController: BaseViewController {

    // MARK: - Life Cycle
    let cardListView = CardListView()
    override func loadView() {
        self.view = cardListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
