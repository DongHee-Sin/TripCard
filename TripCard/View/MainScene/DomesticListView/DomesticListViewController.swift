//
//  DomesticListViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


final class DomesticListViewController: BaseViewController {

    // MARK: - Propertys
    private let repository = TripDataRepository.shared
    
    private let placeHolderLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .largest)
        $0.text = "no_trip_date_created".localized
    }
    
    
    
    
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
        
        setPlaceHolder()
        
        repository.addObserver(to: .domestic) { [weak self] in
            guard let self = self else { return }
            
            self.cardListView.collectionView.reloadData()
            self.placeHolderLabel.isHidden = self.repository.domesticCount != 0
        }
    }
    
    
    private func setPlaceHolder() {
        view.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}




// MARK: - CollectionView Protocol
extension DomesticListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repository.domesticCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        if let trip = repository.fetchTrip(at: indexPath.row, tripType: .domestic) {
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CardViewerViewController()
        vc.selectedIndex = indexPath.item
        vc.tripType = .domestic
        
        let navi = BaseNavigationController(rootViewController: vc)
        transition(navi, transitionStyle: .presentOverFullScreen)
    }
}
