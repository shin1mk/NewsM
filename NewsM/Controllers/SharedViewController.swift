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
    private let refreshControl = UIRefreshControl()
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.refreshControl = refreshControl
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewConstraints()
        fetchSharedArticles()
        setupTarget()
        configureTableView()
    }
    //MARK: Methods
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // API call
    private func fetchSharedArticles() {
        NewsManager.shared.fetchSharedArticles { [weak self] articles, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data from the API: \(error.localizedDescription)")
            } else if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    // Target
    private func setupTarget() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    // Delegate/DataSource
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // Refresh Data
    @objc private func refreshData(_ sender: Any) {
        fetchSharedArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
}
//MARK: extension TableView
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
