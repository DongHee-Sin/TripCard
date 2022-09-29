//
//  OpenSourceWebViewController.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/29.
//

import UIKit
import WebKit


final class OpenSourceWebViewController: BaseViewController {

    // MARK: - Propertys
    private let webView = WKWebView()
    
    var urlString: String?
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("web view DEINIT")
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tabBarController?.tabBar.isHidden = true
        
        openWebView(url: urlString ?? "")
    }
    
    
    private func openWebView(url: String) {
        guard let url = URL(string: url) else {
            showAlert(title: "404", message: "NOT FOUND")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
