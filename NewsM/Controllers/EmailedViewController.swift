//
//  HomeViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

class EmailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "YourCellIdentifier")
        return tableView
    }()
    var articles: [[String: Any]] = []     // Создайте массив для хранения данных
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
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourCellIdentifier", for: indexPath)
        // Наполните ячейку данными из массива articles
        let article = articles[indexPath.row]
        
        if let title = article["title"] as? String {
            cell.textLabel?.text = title
            cell.textLabel?.numberOfLines = 0 // Установите numberOfLines в 0 для текстовой метки
        }
        
        if let publishedDate = article["published_date"] as? String {
            cell.detailTextLabel?.text = "Дата публикации: \(publishedDate)"
        }
        // Другие поля, которые вас интересуют
        return cell
    }
    //MARK: API
    func fetchEmailedArticles() {
        let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
        let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(apiKey)")
        let session = URLSession.shared
        let emailedTask = session.dataTask(with: emailedURL!) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Ошибка при получении данных о самых электронных статьях: \(error.localizedDescription)")
                return
            }
            // разбор JSON
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Вместо вывода данных в консоль, добавьте их в массив
                        if let results = json["results"] as? [[String: Any]] {
                            self.articles = results
                            DispatchQueue.main.async {
                                self.tableView.reloadData() // Обновите таблицу, когда данные будут доступны
                            }
                        }
                    }
                } catch {
                    print("Ошибка при разборе данных JSON: \(error.localizedDescription)")
                }
            }
        }
        emailedTask.resume()
    }
} // end emailedViewController
