//
//  OverseasListViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/09.
//

import UIKit


final class OverseasListViewController: BaseViewController {

    // MARK: - Propertys
    private let repository = TripDataRepository.shared
    
    private let placeHolderLabel = UILabel().then {
        $0.textColor = ColorManager.shared.textColor
        $0.font = .customFont(size: .largest)
        $0.text = "no_trip_date_created".localized
    }
    
    
    
    
    // MARK: - Life Cycle
    private let cardListView = CardListView()
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
        
        repository.addObserver(to: .overseas) { [weak self] in
            guard let self = self else { return }
            
            self.cardListView.collectionView.reloadData()
            self.placeHolderLabel.isHidden = self.repository.overseasCount != 0
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
            cell.updateCell(trip: trip, mainImage: image)
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
