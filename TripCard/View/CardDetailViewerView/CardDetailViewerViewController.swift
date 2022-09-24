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
        return min(contentByDate.count, imageByDate.count)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        return min(contentByDate.count, imageByDate.count)
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CardDetailCollectionViewCell.identifier, at: index) as? CardDetailCollectionViewCell else {
            return FSPagerViewCell()
        }
        
        cell.contentTextView.delegate = self
        cell.updateCell(day: index + 1, content: contentByDate[index], image: imageByDate[index])
        
        return cell
    }
}




// MARK: - TextView Protocol
extension CardDetailViewerViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
