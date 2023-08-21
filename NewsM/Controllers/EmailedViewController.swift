//
//  HomeViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

class EmailedViewController: UIViewController {
    private var articles: [[String: Any]] = []
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
        fetchEmailedArticles()
    }
    //MARK: Methods
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    //MARK: API
    private func fetchEmailedArticles() {
        NewsManager.shared.fetchEmailedArticles { [weak self] articles, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data from the API: \(error.localizedDescription)")
                // Обработайте ошибку, если необходимо
            } else if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData() // Обновите таблицу, когда данные будут доступны
                }
                print("Parsed articles: \(articles)")
            }
        }
    }
} // end emailedViewController
//MARK: TableView
extension EmailedViewController: UITableViewDelegate, UITableViewDataSource{
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
        cell.backgroundColor = UIColor.black
        
        let article = articles[indexPath.row]
        // Title
        if let title = article["title"] as? String {
            let truncatedTitle = String(title.prefix(60))
            cell.titleText = truncatedTitle
        }
        // Publication Date
        if let publishedDate = article["published_date"] as? String {
            cell.dateText = "\(publishedDate)"
        }
        if let urlStr = article["url"] as? String, let url = URL(string: urlStr) {
            cell.articleURL = url
        }
        return cell
    }
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell,
           let articleURL = cell.articleURL {
            let webViewController = WebViewController()
            webViewController.articleURL = articleURL
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
