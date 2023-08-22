//
//  SharedViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

final class SharedViewController: UIViewController {
    private var articles: [NewsArticle] = []
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
        setupTableViewConstraints()
        fetchSharedArticles()
    }
    //MARK: Methods
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    //MARK: API
    private func fetchSharedArticles() {
        NewsManager.shared.fetchSharedArticles { [weak self] articles, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data from the API: \(error.localizedDescription)")
                // Обработайте ошибку, если необходимо
            } else if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Parsed articles: \(articles)")
            }
        }
    }
} // end
//MARK: TableView
extension SharedViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let article = articles[indexPath.row]
        cell.backgroundColor = UIColor.black
        // юзаем свойства структуры
        cell.newsArticle = article
        return cell
    }
    //MARK: didSelectRowAt
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
