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
    weak var delegate: FavoritesViewControllerDelegate?

    var webViewController: WebViewController?

    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavoriteArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteArticles()
    }
    //MARK: Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // load Favorites
    func loadFavoriteArticles() {
        favoriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
        tableView.reloadData()
    }
} // end
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        let favoriteArticle = favoriteArticles[indexPath.row]

        cell.newsArticle = NewsArticle(
            title: favoriteArticle.title ?? "",
            abstract: favoriteArticle.abstract ?? "",
            url: favoriteArticle.url ?? "",
            publishedDate: favoriteArticle.publishedDate ?? "",
            mediaMetadata: []
        )
        
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

//extension FavoritesViewController: FavoritesViewControllerDelegate {
//    func didAddArticleToFavorites() {
//        loadFavoriteArticles()
//    }
//}
