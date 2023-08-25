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
    // MARK: Properties
    var didAddArticleToFavorites: (() -> Void)?
    private var isStarred: Bool = false
    var newsArticle: NewsArticle? {
        didSet {
            if let newsArticle = newsArticle {
                isStarred = newsArticle.isFavorite
            }
        }
    }
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebViewConstraints()
        loadArticleURL()
        setupStarButton()
        updateStarButtonAppearance()
    }
    // MARK: Methods
    private func setupWebViewConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // loadArticleURL
    private func loadArticleURL() {
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
            
            if findExistingFavorite(urlStr) != nil {
                newsArticle?.isFavorite = true
            }
        }
    }
    //MARK: StarButton
    private func setupStarButton() {
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        navigationItem.rightBarButtonItems = [starButton]
    }
    // StarButtonAction
    @objc private func starButtonAction() {
        isStarred.toggle()
        
        if var article = newsArticle {
            article.isFavorite = isStarred
            newsArticle = article
        }
        
        updateStarButtonAppearance()
        
        if isStarred {
            addToFavorites()
        } else {
            removeFromFavorites()
        }
        
        updateStarButtonAppearance()
    }
    // StarButtonAppearance
    private func updateStarButtonAppearance() {
        if isStarred {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
    }
    //MARK: AddToFavorites
    private func addToFavorites() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if findExistingFavorite(newsArticle?.url ?? "") == nil {
            let favoriteArticle = FavoriteArticle(context: context)
            favoriteArticle.title = newsArticle?.title
            favoriteArticle.abstract = newsArticle?.abstract
            favoriteArticle.url = newsArticle?.url
            favoriteArticle.publishedDate = newsArticle?.publishedDate

            CoreDataManager.shared.saveContext()
            print("Article added to favorites")
            
            DispatchQueue.main.async {
                self.didAddArticleToFavorites?()
            }
        }
    }
    //MARK: RemoveFromFavorites
    private func removeFromFavorites() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let existingFavorite = findExistingFavorite(newsArticle?.url ?? "") {
            context.delete(existingFavorite)
            CoreDataManager.shared.saveContext()
            print("Article removed from favorites")
        }
    }
    //MARK: findExistingFavorite
    private func findExistingFavorite(_ url: String) -> FavoriteArticle? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites.first
        } catch {
            print("Error fetching favorites: \(error)")
            return nil
        }
    }
}

