//
//  OpenSourceListViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/29.
//

import UIKit


enum OpenSourceList: String, CaseIterable {
    case FSCalendar
    case FSPagerView
    case IQKeyboardManagerSwift
    case Realm
    case SnapKit
    case Tabman
    case TextFieldEffects
    case Then
    case ToCropViewController
    case Zip
    case GooglePlaces = "Google Places SDK"
    case Firebase
    
    var url: String {
        switch self {
        case .FSCalendar:
            return baseURL + "WenchaoD/FSCalendar"
        case .FSPagerView:
            return baseURL + "WenchaoD/FSPagerView"
        case .IQKeyboardManagerSwift:
            return baseURL + "hackiftekhar/IQKeyboardManager"
        case .Realm:
            return baseURL + "realm/realm-swift"
        case .SnapKit:
            return baseURL + "SnapKit/SnapKit"
        case .Tabman:
            return baseURL + "uias/Tabman"
        case .TextFieldEffects:
            return baseURL + "raulriera/TextFieldEffects"
        case .Then:
            return baseURL + "devxoul/Then"
        case .ToCropViewController:
            return baseURL + "TimOliver/TOCropViewController"
        case .Zip:
            return baseURL + "marmelroy/Zip"
        case .GooglePlaces:
            return baseURL + "googlemaps/"
        case .Firebase:
            return baseURL + "firebase/firebase-ios-sdk"
        }
    }
    
    private var baseURL: String { "https://github.com/" }
}


final class OpenSourceListViewController: BaseViewController {

    // MARK: - Protocol
    private let openSourceList = OpenSourceList.allCases
    
    
    
    
    // MARK: - Life Cycle
    let OpenSourceListView = ReusableTableCustomView()
    override func loadView() {
        self.view = OpenSourceListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        OpenSourceListView.tableView.delegate = self
        OpenSourceListView.tableView.dataSource = self
        
        navigationItem.title = "opensource".localized
    }
}




// MARK: - TableView Protocol
extension OpenSourceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSourceList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell()
        
        cell.textLabel?.text = openSourceList[indexPath.row].rawValue
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webView = OpenSourceWebViewController()
        webView.urlString = openSourceList[indexPath.row].url
        
        transition(webView, transitionStyle: .push)
    }
}
