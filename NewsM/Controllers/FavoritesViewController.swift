//
//  FavoritesViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
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
    }
    //MARK: Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        return 10
    }
    //MARK: cellForRowAt:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            
            // Создаем тестовую статью с ссылкой на "google.com" для проверки
            let testArticle = NewsArticle(title: "Google",
                                          abstract: "Google's homepage",
                                          url: "https://www.google.com",
                                          publishedDate: "August 22, 2023",
                                          mediaMetadata: [])
            
            cell.newsArticle = testArticle
            
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
