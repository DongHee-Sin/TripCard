//
//  CardViewerViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/18.
//

import UIKit
import FSPagerView


final class CardViewerViewController: BaseViewController {

    // MARK: - Propertys
    let repository = TripDataRepository.shared
    
    var selectedIndex: Int?
    var tripType: TripType?
    
    private var currentIndex: Int {
        cardViewerView.pagerView.currentIndex
    }
    
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
        cardViewerView.pagerView.delegate = self
        cardViewerView.pagerView.dataSource = self
        cardViewerView.pagerView.register(CardViewerCollectionViewCell.self, forCellWithReuseIdentifier: CardViewerCollectionViewCell.identifier)
        
        cardViewerView.pagerView.itemSize = fetchCardSize()
    }
    
    
    private func fetchCardSize() -> CGSize {
        let width = UIScreen.main.bounds.width - 88
        let height = (width * 1.25) + 100
        
        return CGSize(width: width, height: height)
    }
    
    
    private func setNavigationBarButtonItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        let modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonTapped))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTapped))
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItems = [deleteButton, modifyButton]
    }
     
    
    private func moveToSelectedCard() {
        if let selectedIndex = selectedIndex {
            scrollToItem(at: selectedIndex)
        }
    }
    
    
    private func scrollToItem(at index: Int) {
        cardViewerView.pagerView.scrollToItem(at: index, animated: false)
    }
    
    
    @objc private func modifyButtonTapped() throws {
        let modifyVC = WriteViewController()
        
        guard let toModifyData = self.fetchTrip() else { return }
        
        let mainImage = try repository.documentManager.loadMainImageFromDocument(directoryName: toModifyData.objectId.stringValue)
        let imageByDate = try repository.documentManager.loadImagesFromDocument(directoryName: toModifyData.objectId.stringValue, numberOfTripDate: toModifyData.numberOfDate)
        
        modifyVC.updateViewModel(mainImage: mainImage, imageByDate: imageByDate, trip: toModifyData)
        
        modifyVC.modifyCardCompletion = { [weak self] in
            guard let self = self else { return }
            self.cardViewerView.pagerView.reloadData()
        }
        
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
        guard let tripType = self.tripType else { return nil }
        
        return repository.fetchTrip(at: currentIndex, tripType: tripType)
    }
}




// MARK: - PagerView Protocol
extension CardViewerViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfCard
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CardViewerCollectionViewCell.identifier, at: index) as? CardViewerCollectionViewCell else {
            return FSPagerViewCell()
        }
        
        guard let tripType = tripType else { return FSPagerViewCell() }
        
        if let trip = repository.fetchTrip(at: index, tripType: tripType) {
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
   
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let detailVC = CardDetailViewerViewController()

        if let tripType = tripType, let trip = repository.fetchTrip(at: index, tripType: tripType) {
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
