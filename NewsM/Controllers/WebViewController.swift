//
//  WebViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 21.08.2023.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    var articleURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebViewConstraints()
        loadArticleURL()
    }
    // Setup Navigation Bar
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    // Setup WebView Constraints
    private func setupWebViewConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // Load Article URL
    private func loadArticleURL() {
        if let url = articleURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
