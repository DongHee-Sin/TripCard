//
//  WriteByDateViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/14.
//

import UIKit

class WriteByDateViewController: BaseViewController {

    // MARK: - Life Cycle
    let writeByDateView = WriteByDateView()
    override func loadView() {
        self.view = writeByDateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
