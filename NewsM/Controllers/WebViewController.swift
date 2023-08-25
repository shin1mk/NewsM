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
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebViewConstraints()
        loadArticleURL()
        starButton()
        updateStarButtonAppearance() // Обновляем начальный вид кнопки

    }
    //MARK: Methods
    private func setupWebViewConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // Load Article URL
    private func loadArticleURL() {
        // Когда открываете статью в веб-вью, установите isFavorite
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
            
            // Проверяем, является ли статья избранной
            if let existingFavorite = findExistingFavorite(urlStr) {
                newsArticle?.isFavorite = true
            }
        }
    }

    //MARK: Star Button
    private func starButton() {
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        navigationItem.rightBarButtonItems = [starButton]
    }
    
    /*
    // starButtonAction
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
            
            DispatchQueue.main.async {
                // Вызываем блок обратного вызова, если он установлен
                self.didAddArticleToFavorites?()
            }
            // Создаем UIAlertController для вывода уведомления
            let alertController = UIAlertController(title: "Added to Favorites", message: "This article has been added to your favorites.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
     */
    @objc private func starButtonAction() {
        // Изменяем состояние кнопки (нажата/не нажата)
        isStarred.toggle()
        
        if var article = newsArticle {
            article.isFavorite = isStarred
            newsArticle = article // Обновляем новости с новым состоянием
        }
        // Обновляем внешний вид кнопки на основе нового состояния
        updateStarButtonAppearance()
        
        if isStarred {
            // Если кнопка нажата, добавляем статью в избранное
            addToFavorites()
        } else {
            // Если кнопка не нажата, удаляем статью из избранного
            removeFromFavorites()
        }
        
        updateStarButtonAppearance()
    }
    
    private func updateStarButtonAppearance() {
        if isStarred {
            // Установите изображение для кнопки, когда она нажата
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            // Установите изображение для кнопки, когда она не нажата
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
    }

    private func addToFavorites() {
        // Получаем контекст CoreData
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // Проверяем, существует ли статья в избранном по её URL
        if findExistingFavorite(newsArticle?.url ?? "") == nil {
            // Если статья не существует в избранном, создаем новый объект FavoriteArticle
            let favoriteArticle = FavoriteArticle(context: context)
            favoriteArticle.title = newsArticle?.title
            favoriteArticle.abstract = newsArticle?.abstract
            favoriteArticle.url = newsArticle?.url
            favoriteArticle.publishedDate = newsArticle?.publishedDate

            CoreDataManager.shared.saveContext()
            print("Article added to favorites")
            
            DispatchQueue.main.async {
                // Вызываем блок обратного вызова, если он установлен
                self.didAddArticleToFavorites?()
            }
            // Создаем UIAlertController для вывода уведомления
            let alertController = UIAlertController(title: "Added to Favorites", message: "This article has been added to your favorites.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    private func removeFromFavorites() {
        // Получаем контекст CoreData
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // Ищем существующую избранную статью по URL
        if let existingFavorite = findExistingFavorite(newsArticle?.url ?? "") {
            // Удаляем статью из избранного
            context.delete(existingFavorite)
            CoreDataManager.shared.saveContext()
            print("Article removed from favorites")
        }
    }


    private func findExistingFavorite(_ url: String) -> FavoriteArticle? {
        // Проверяем, существует ли статья в избранном по её URL
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
