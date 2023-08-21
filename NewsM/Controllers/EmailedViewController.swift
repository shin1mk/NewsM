//
//  HomeViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit
import SafariServices


class EmailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    var articles: [[String: Any]] = []     // Создайте массив для хранения данных
    var articleURL: URL?
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupTableViewConstraints()
        fetchEmailedArticles() // call method api
    }
    //MARK: Methods
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    //MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0 // высота ячейки
    }
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

       
        let article = articles[indexPath.row]
        // Title (limited to 50 characters)
        if let title = article["title"] as? String {
            let truncatedTitle = String(title.prefix(50))
            cell.titleLabel.text = truncatedTitle
            cell.titleLabel.numberOfLines = 2 // Установите количество строк в 2
        }
        // Publication Date
        if let publishedDate = article["published_date"] as? String {
            cell.dateLabel.text = "\(publishedDate)"
        }
        // URL (можете добавить кнопку или ссылку в соответствии с вашим интерфейсом)
        if let urlStr = article["url"] as? String, let url = URL(string: urlStr) {
            cell.articleURL = url // передаем URL ячейке
        }
        return cell
    }
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell,
           let articleURL = cell.articleURL {
            let safariViewController = SFSafariViewController(url: articleURL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    //MARK: API
    func fetchEmailedArticles() {
        let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
        let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(apiKey)")
        let session = URLSession.shared
        let emailedTask = session.dataTask(with: emailedURL!) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data from the API: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Received JSON data: \(json)")
                        
                        // Extract articles from the "results" array
                        if let results = json["results"] as? [[String: Any]] {
                            var parsedArticles: [[String: Any]] = []
                            for result in results {
                                if let title = result["title"] as? String,
                                   let abstract = result["abstract"] as? String,
                                   let url = result["url"] as? String,
                                   let publishedDate = result["published_date"] as? String {
                                    let article = ["title": title,
                                                   "abstract": abstract,
                                                   "url": url,
                                                   "published_date": publishedDate]
                                    parsedArticles.append(article)
                                }
                            }
                            self.articles = parsedArticles
                            DispatchQueue.main.async {
                                self.tableView.reloadData() // Обновите таблицу, когда данные будут доступны
                            }
                            print("Parsed articles: \(parsedArticles)")
                        }
                    }
                } catch {
                    print("Error parsing JSON data: \(error.localizedDescription)")
                }
            }
        }
        emailedTask.resume()
    }
} // end emailedViewController
