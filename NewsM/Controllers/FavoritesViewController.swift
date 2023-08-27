//
//  FavoritesViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import UIKit
import SnapKit
import CoreData

protocol FavoritesViewControllerDelegate: AnyObject {
    func didAddArticleToFavorites()
}

final class FavoritesViewController: UIViewController {
    private var favoriteArticles: [FavoriteArticle] = []
    private var newsArticles: [NewsArticle] = []
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavoriteArticlesFromCoreData()
        configureTableView()
    }
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteArticlesFromCoreData()
    }
    //MARK: Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // Delegate/DataSource
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // load Favorites
    private func loadFavoriteArticlesFromCoreData() {
        favoriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
        // Обновляем состояние isFavorite для каждой статьи в соответствии с данными
        favoriteArticles.forEach { favoriteArticle in
            if let index = newsArticles.firstIndex(where: { $0.url == favoriteArticle.url }) {
                newsArticles[index].isFavorite = true
            }
        }
        tableView.reloadData() // перезагружаем таблицу
    }
}
//MARK: extension TableView
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let favoriteArticle = favoriteArticles[indexPath.row]
        var newsArticle = NewsArticle(
            title: favoriteArticle.title ?? "",
            abstract: favoriteArticle.abstract ?? "",
            url: favoriteArticle.url ?? "",
            publishedDate: favoriteArticle.publishedDate ?? "",
            mediaMetadata: [],
            isFavorite: true
        )
        // Установите imageURL в newsArticle
        if let imageURLString = favoriteArticle.imageURL {
            newsArticle.mediaMetadata = [MediaMetadata(url: imageURLString, format: "", height: 0, width: 0)]
        }
        cell.newsArticle = newsArticle
        return cell
    }
    //MARK: didSelectRowAt:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell,
           let newsArticle = cell.newsArticle {
            let webViewController = WebViewController()
            webViewController.newsArticle = newsArticle // Передали экземпляр NewsArticle
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
