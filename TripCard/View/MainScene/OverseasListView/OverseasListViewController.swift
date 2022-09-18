//
//  OverseasListViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit

final class OverseasListViewController: BaseViewController {

    // MARK: - Propertys
    let repository = TripDataRepository.shared
    
    
    
    
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
        return repository.overseasCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        if let trip = repository.fetchTrip(at: indexPath.row, isDomestic: false) {
            var image: UIImage?
            do {
                image = try repository.documentManager.loadMainImageFromDocument(directoryName: trip.objectId.stringValue)
            }
            catch {
                showErrorAlert(error: error)
            }
            cell.updateCell(trip: trip, mainImage: image)
        }
        
        return cell
    }
}
