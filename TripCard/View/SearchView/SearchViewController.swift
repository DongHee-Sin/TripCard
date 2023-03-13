//
//  SearchViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/29.
//

import UIKit


final class SearchViewController: BaseViewController {

    // MARK: - Propertys
    private var viewModel = SearchViewModel()
    
    
    
    
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
        setCollectionView()
        setNavigationBar()
        setSearchController()
        addCompletionToViewModelPropertys()
    }
    
    
    private func setCollectionView() {
        cardListView.collectionView.delegate = self
        cardListView.collectionView.dataSource = self
        cardListView.collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
    }
    
    
    private func setNavigationBar() {
        navigationItem.title = "search".localized
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "search_bar_place_holder".localized
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    
    private func addCompletionToViewModelPropertys() {
        viewModel.searchKeyWord.bind { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateSearchResult()
            self.cardListView.collectionView.reloadData()
        }
    }
}




// MARK: - CollectionView Protocol
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        do {
            if let tripData = try viewModel.fetchTripData(at: indexPath.item) {
                cell.updateCell(trip: tripData.trip, mainImage: tripData.image, searchKeyWord: viewModel.searchKeyWord.value)
            }
        }
        catch {
            showErrorAlert(error: error)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CardViewerViewController()
        
        if let tripType = viewModel.fetchTripType(at: indexPath.item), let selectedIndex = viewModel.selectedIndexInRealm(at: indexPath.item, tripType: tripType) {
            vc.selectedIndex = selectedIndex
            vc.tripType = tripType
        }
        
        let navi = BaseNavigationController(rootViewController: vc)
        transition(navi, transitionStyle: .presentOverFullScreen)
    }
}




// MARK: - SearchController Protocol
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchKeyWord.value = searchController.searchBar.text
    }
}
