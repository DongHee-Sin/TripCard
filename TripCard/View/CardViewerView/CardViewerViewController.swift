//
//  CardViewerViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/18.
//

import UIKit

final class CardViewerViewController: BaseViewController {

    // MARK: - Propertys
    let repository = TripDataRepository.shared
    
    var selectedIndex: Int?                        // 이부분은 이니셜라이저로 빼면 옵셔널바인딩 과정 없이 사용할 수 있을듯?? 개선가능?
    var tripType: TripType?
    
    var numberOfCard: Int {
        guard let tripType = tripType else { return 1 }
        
        switch tripType {
        case .domestic:
            return repository.domesticCount
        case .overseas:
            return repository.overseasCount
        }
    }
    
    
    
    
    // MARK: - Life Cycle
    let cardViewerView = CardViewerView()
    override func loadView() {
        self.view = cardViewerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToSelectedCard()
    }
    
    
    
    // MARK: - Methods
    override func configure() {
        setCollectionView()
        
        setNavigationBarButtonItem()
    }
    
    
    private func setCollectionView() {
        cardViewerView.collectionView.delegate = self
        cardViewerView.collectionView.dataSource = self
        cardViewerView.collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
    }
    
    
    private func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    
    private func moveToSelectedCard() {
        guard let selectedIndex = selectedIndex else { return }
        cardViewerView.collectionView.scrollToItem(at: IndexPath(item: 0, section: selectedIndex), at: .centeredHorizontally, animated: false)
        cardViewerView.collectionView.isPagingEnabled = true
    }
}




// MARK: - CollectionView Protocol
extension CardViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfCard
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        guard let tripType = tripType else { return UICollectionViewCell() }
        
        if let trip = repository.fetchTrip(at: indexPath.section, tripType: tripType) {
            var image: UIImage?
            do {
                image = try repository.documentManager.loadMainImageFromDocument(directoryName: trip.objectId.stringValue)
            }
            catch {
                showErrorAlert(error: error)
            }
            
            cell.updateCell(trip: trip, mainImage: image, type: .card)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = CardDetailViewerViewController()
        
        if let tripType = tripType, let trip = repository.fetchTrip(at: indexPath.section, tripType: tripType) {
            do {
                var contentByDate: [String?] = []
                contentByDate.append(contentsOf: trip.contentByDate)
                let imageByDate = try repository.documentManager.loadImagesFromDocument(directoryName: trip.objectId.stringValue, numberOfTripDate: trip.numberOfDate)
                
                detailVC.contentByDate = contentByDate
                detailVC.imageByDate = imageByDate
            }
            catch {
                showErrorAlert(error: error)
            }
        }
        
        transition(detailVC, transitionStyle: .presentFullScreen)
    }
}
