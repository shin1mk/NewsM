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
    var didAddArticleToFavorites: (() -> Void)? // протокол
    var newsArticle: NewsArticle? {
        didSet {
            if let newsArticle = newsArticle {
                isStarred = newsArticle.isFavorite
            }
        }
    }
    private var isStarred: Bool = false
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebViewConstraints()
        loadArticleURL()
        setupStarShareButton()
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
        guard let urlStr = newsArticle?.url, let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        
        if findExistingFavorite(urlStr) != nil {
            newsArticle?.isFavorite = true
        }
    }
    // find Existing Favorite
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
    // Add To Favorites
    private func addToFavorites() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let url = newsArticle?.url ?? ""
        
        if findExistingFavorite(url) == nil {
            let favoriteArticle = FavoriteArticle(context: context)
            favoriteArticle.title = newsArticle?.title
            favoriteArticle.abstract = newsArticle?.abstract
            favoriteArticle.url = url
            favoriteArticle.publishedDate = newsArticle?.publishedDate
            favoriteArticle.imageURL = newsArticle?.mediaMetadata.first?.url
            
            CoreDataManager.shared.saveContext()
            print("Article added to favorites")
            DispatchQueue.main.async {
                self.didAddArticleToFavorites?()
            }
        }
    }
    // Remove From Favorites
    private func removeFromFavorites() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let existingFavorite = findExistingFavorite(newsArticle?.url ?? "") {
            context.delete(existingFavorite)
            CoreDataManager.shared.saveContext()
            print("Article added to favorites")
        }
    }
}
//MARK: - Star Button
extension WebViewController {
    // setup Star Button
    private func setupStarShareButton() {
        // Favorite
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        // Share
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [starButton, shareButton]
    }
    // Star Button Appearance
    private func updateStarButtonAppearance() {
           if isStarred {
               navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
           } else {
               navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
           }
       }
    // Star Button Action
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
    }
    // Share Button Action
    @objc func shareTapped() {
        // Получаем текущий URL и можем его копировать
        if let currentURL = webView.url {
            let activityViewController = UIActivityViewController(activityItems: [currentURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
}
