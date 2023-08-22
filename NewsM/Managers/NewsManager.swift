//
//  NewsManager.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//
// FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl

import Foundation

final class NewsManager {
    static let shared = NewsManager() // Создайте синглтон NewsManager для общего доступа к функции
    //MARK: fetchEmailedArticles
    func fetchEmailedArticles(completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
        let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(apiKey)")
        let session = URLSession.shared
        
        let emailedTask = session.dataTask(with: emailedURL!) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
                            completion(parsedArticles, nil)
                        }
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }
        emailedTask.resume()
    }
}



































/*
func fetchSharedArticles() {
    let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
    let sharedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/shared/1.json?api-key=\(apiKey)")
    let session = URLSession.shared
    
    let sharedTask = session.dataTask(with: sharedURL!) { (data, response, error) in
        if let error = error {
            print("Ошибка при получении данных о самых популярных статьях: \(error.localizedDescription)")
            return
        }
        // Здесь можно разбирать полученные данные в формате JSON для самых популярных статей.
    }
    
    sharedTask.resume()
}

func fetchViewedArticles() {
    let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
    let viewedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=\(apiKey)")
    let session = URLSession.shared
    
    let viewedTask = session.dataTask(with: viewedURL!) { (data, response, error) in
        if let error = error {
            print("Ошибка при получении данных о самых просматриваемых статьях: \(error.localizedDescription)")
            return
        }
        // Здесь можно разбирать полученные данные в формате JSON для самых просматриваемых статей.
    }
    
    viewedTask.resume()
}
*/
