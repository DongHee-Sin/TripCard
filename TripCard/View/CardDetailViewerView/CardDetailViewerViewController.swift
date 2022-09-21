//
//  CardDetailViewerViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit

final class CardDetailViewerViewController: BaseViewController {

    // MARK: - Propertys
    var contentByDate: [String?] = []
    var imageByDate: [UIImage?] = []
    

    
    
    // MARK: - Life Cycle
    let cardDetailViewerView = CardDetailViewerView()
    override func loadView() {
        self.view = cardDetailViewerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setCollectionView()
    }
    
    
    private func setCollectionView() {
        cardDetailViewerView.dateCollectionView.delegate = self
        cardDetailViewerView.dateCollectionView.dataSource = self
        cardDetailViewerView.dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        
        cardDetailViewerView.cardCollectionView.delegate = self
        cardDetailViewerView.cardCollectionView.dataSource = self
        cardDetailViewerView.cardCollectionView.register(CardDetailCollectionViewCell.self, forCellWithReuseIdentifier: CardDetailCollectionViewCell.identifier)
    }
}




// MARK: - CollectionView Protocol
extension CardDetailViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(contentByDate.count, imageByDate.count)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == cardDetailViewerView.dateCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if contentByDate[indexPath.item] != nil || imageByDate[indexPath.item] != nil {
                cell.backgroundColor = ColorManager.shared.selectedColor
            }else {
                cell.backgroundColor = .systemGray5
            }
            
            cell.updateCell(day: indexPath.item + 1)
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardDetailCollectionViewCell.identifier, for: indexPath) as? CardDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.contentTextView.delegate = self
            cell.updateCell(day: indexPath.item + 1, content: contentByDate[indexPath.item], image: imageByDate[indexPath.item])
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardDetailViewerView.dateCollectionView {
            
            cardDetailViewerView.cardCollectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}




// MARK: - TextView Protocol
extension CardDetailViewerViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
