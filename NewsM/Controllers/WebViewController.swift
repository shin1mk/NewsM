//
//  WebViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 21.08.2023.
//

import UIKit
import WebKit
import SnapKit
import CoreData

class WebViewController: UIViewController {
    //MARK: Properties
    var newsArticle: NewsArticle?
    private var isStarred = false
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebViewConstraints()
        loadArticleURL()
        starButton()
    }
    //MARK: Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
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
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    //MARK: Star Button
    private func starButton() {
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        navigationItem.rightBarButtonItems = [starButton]
    }

    // star button action
//    @objc private func starButtonAction() {
//        isStarred.toggle()
//        starButton()
//        print("starButtonAction")
//    }
    @objc private func starButtonAction() {
        isStarred.toggle()
        starButton()
        
        if isStarred {
            // Получаем контекст CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            // Создаем объект FavoriteArticle и заполняем его свойства
            let favoriteArticle = FavoriteArticle(context: context)
            favoriteArticle.title = newsArticle?.title
            favoriteArticle.abstract = newsArticle?.abstract
            favoriteArticle.url = newsArticle?.url
            favoriteArticle.publishedDate = newsArticle?.publishedDate

            CoreDataManager.shared.saveContext()
            
            print("Article added to favorites")
        }
    }

}
