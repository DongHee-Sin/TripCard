//
//  BackupRestoreViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/21.
//

import UIKit

final class BackupRestoreViewController: BaseViewController {

    // MARK: - Life Cycle
    let backupRestoreView = BackupRestoreView()
    override func loadView() {
        self.view = backupRestoreView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        navigationItem.title = "백업 / 복원"
    }
}
