//
//  LocationSearchViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/10/06.
//

import UIKit
import GooglePlaces


protocol AddLocationDelegate: AnyObject {
    func addLocation(location: String)
}


final class LocationSearchViewController: BaseViewController {

    // MARK: - Propertys
    private lazy var tableDataSource = {
        let dataSource = GMSAutocompleteTableDataSource()
        dataSource.delegate = self
        return dataSource
    }()
    
    weak var delegate: AddLocationDelegate?
    
    
    
    
    // MARK: - Life Cycle
    let locationSearchView = LocationSearchView()
    override func loadView() {
        self.view = locationSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        locationSearchView.searchBar.delegate = self
        locationSearchView.tableView.delegate = tableDataSource
        locationSearchView.tableView.dataSource = tableDataSource
    }
}




// MARK: - SearchBar Protocol
extension LocationSearchViewController: UISearchBarDelegate {
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        //
//    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        locationSearchView.searchBar.endEditing(true)
        locationSearchView.searchBar.text = ""
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableDataSource.sourceTextHasChanged(searchText)
    }
    
}




// MARK: - TableView Protocol
extension LocationSearchViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        locationSearchView.tableView.reloadData()
    }
    
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        locationSearchView.tableView.reloadData()
    }
    
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        delegate?.addLocation(location: place.name ?? "")
        
        locationSearchView.searchBar.endEditing(true)
        
        dismiss(animated: true)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        showErrorAlert(error: error)
    }
    

    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}
