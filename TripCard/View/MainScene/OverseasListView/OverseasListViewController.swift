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
        
        repository.addObserver(to: .overseas) { [weak self] in
            self?.cardListView.collectionView.reloadData()
        }
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
        
        if let trip = repository.fetchTrip(at: indexPath.row, tripType: .overseas) {
            var image: UIImage?
            do {
                image = try repository.documentManager.loadMainImageFromDocument(directoryName: trip.objectId.stringValue)
            }
            catch {
                showErrorAlert(error: error)
            }
            cell.updateCell(trip: trip, mainImage: image, type: .list)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CardViewerViewController()
        vc.selectedIndex = indexPath.item
        vc.tripType = .overseas
        
        let navi = BaseNavigationController(rootViewController: vc)
        transition(navi, transitionStyle: .presentOverFullScreen)
    }
}
