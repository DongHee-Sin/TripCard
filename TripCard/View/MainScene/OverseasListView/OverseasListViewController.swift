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
    
    
    
    
    // MARK: - Methods
    override func configure() {
        cardListView.collectionView.delegate = self
        cardListView.collectionView.dataSource = self
        cardListView.collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
    }
}




// MARK: - CollectionView Protocol
extension OverseasListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        cell.contentLabel.isHidden = true
        
        return cell
    }
}
