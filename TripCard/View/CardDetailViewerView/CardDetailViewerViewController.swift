//
//  CardDetailViewerViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/19.
//

import UIKit
import FSPagerView


final class CardDetailViewerViewController: BaseViewController {

    // MARK: - Propertys
    var contentByDate: [String?] = []
    var imageByDate: [UIImage?] = []
    
    lazy var cardByDate: [(index: Int, content: String?, image: UIImage?)] = {
        let zip = zip(contentByDate, imageByDate)
        var result: [(index: Int, content: String?, image: UIImage?)] = []
        
        for (index, card) in zip.enumerated() {
            if card.0 != nil || card.1 != nil {
                result.append((index: index, content: card.0, image: card.1))
            }
        }
        
        return result
    }()
    

    
    
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
        
        cardDetailViewerView.pagerView.delegate = self
        cardDetailViewerView.pagerView.dataSource = self
        cardDetailViewerView.pagerView.register(CardDetailCollectionViewCell.self, forCellWithReuseIdentifier: CardDetailCollectionViewCell.identifier)
        
        cardDetailViewerView.pagerView.itemSize = fetchCardSize()
    }
    
    
    private func fetchCardSize() -> CGSize {
        var isNotch: Bool {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return Double(window?.safeAreaInsets.bottom ?? -1) > 0
        }
        
        let width = UIScreen.main.bounds.width - 40
        let height = UIScreen.main.bounds.height - (isNotch ? 200 : 150)
        
        return CGSize(width: width, height: height)
    }
}




// MARK: - CollectionView Protocol
extension CardDetailViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardByDate.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.updateCell(day: cardByDate[indexPath.row].index + 1)

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardDetailViewerView.dateCollectionView {

            cardDetailViewerView.pagerView.scrollToItem(at: indexPath.item, animated: true)
        }
    }
}



// MARK: - PagerView Protocol
extension CardDetailViewerViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return cardByDate.count
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CardDetailCollectionViewCell.identifier, at: index) as? CardDetailCollectionViewCell else {
            return FSPagerViewCell()
        }
        
        cell.contentTextView.delegate = self
        cell.updateCell(day: cardByDate[index].index + 1, content: cardByDate[index].content, image: cardByDate[index].image)
        
        return cell
    }
}




// MARK: - TextView Protocol
extension CardDetailViewerViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
