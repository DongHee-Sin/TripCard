//
//  WriteViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/13.
//

import UIKit


final class WriteViewController: BaseViewController {

    // MARK: - Life Cycle
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setNavigationBarButtonItem()
        
        dismissKeyboardWhenTappedAround()
    }
    
    
    func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        let addTripButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(addTripButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addTripButton
    }
    
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc private func addTripButtonTapped() {
        print("데이터 추가")
    }
    
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
