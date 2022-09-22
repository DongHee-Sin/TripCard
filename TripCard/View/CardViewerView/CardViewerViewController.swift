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
    
    var selectedIndex: Int?
    var tripType: TripType?
    
    var currentCardIndex: Int?
    
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
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.moveToSelectedCard()
        }
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
        let modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonTapped))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [deleteButton, modifyButton]
    }
    
    
    private func moveToSelectedCard() {
        if let currentCardIndex = currentCardIndex {
            scrollToItem(at: currentCardIndex)
            return
        }
        
        if let selectedIndex = selectedIndex {
            scrollToItem(at: selectedIndex)
            currentCardIndex = selectedIndex
        }
    }
    
    
    private func scrollToItem(at index: Int) {
        cardViewerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        cardViewerView.collectionView.isPagingEnabled = true
    }
    
    
    @objc private func modifyButtonTapped() throws {
        let modifyVC = WriteViewController()
        
        guard let toModifyData = self.fetchTrip() else { return }
        
        let mainImage = try repository.documentManager.loadMainImageFromDocument(directoryName: toModifyData.objectId.stringValue)
        let imageByDate = try repository.documentManager.loadImagesFromDocument(directoryName: toModifyData.objectId.stringValue, numberOfTripDate: toModifyData.numberOfDate)
        
        modifyVC.updateViewModel(mainImage: mainImage, imageByDate: imageByDate, trip: toModifyData)
        
        modifyVC.modifyCardCompletion = { [weak self] in
            guard let self = self else { return }
            self.cardViewerView.collectionView.reloadData()
        }
        
        self.cardViewerView.collectionView.isPagingEnabled = false
        
        let navi = BaseNavigationController(rootViewController: modifyVC)
        transition(navi, transitionStyle: .presentFullScreen)
    }
    
    
    @objc private func deleteButtonTapped() throws {
        showAlert(title: "정말 삭제하실 건가요???", buttonTitle: "삭제하기", cancelTitle: "취소") { [weak self] _ in
            guard let self = self else { return }
            
            guard let toRemoveData = self.fetchTrip() else { return }
            
            do {
                try self.repository.remove(trip: toRemoveData)
            }
            catch {
                self.showErrorAlert(error: error)
            }
            
            self.dismiss(animated: true)
        }
    }
    
    
    private func fetchTrip() -> Trip? {
        guard let currentCardIndex = self.currentCardIndex, let tripType = self.tripType else { return nil }
        
        return repository.fetchTrip(at: currentCardIndex, tripType: tripType)
    }
}




// MARK: - CollectionView Protocol
extension CardViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCard
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        guard let tripType = tripType else { return UICollectionViewCell() }
        
        if let trip = repository.fetchTrip(at: indexPath.item, tripType: tripType) {
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let cell = cardViewerView.collectionView.visibleCells.first else { return }
        
        let indexPath = cardViewerView.collectionView.indexPath(for: cell)
        
        currentCardIndex = indexPath?.item
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = CardDetailViewerViewController()
        
        if let tripType = tripType, let trip = repository.fetchTrip(at: indexPath.item, tripType: tripType) {
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
        
        transition(detailVC, transitionStyle: .present)
    }
}
