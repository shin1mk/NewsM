//
//  NewsManager.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//
// FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl
//func fetchMostPopularArticles() {
//    let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
//    // URL-адреса для разных категорий
//    let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(apiKey)")
//    let sharedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=\(apiKey)")
//    let viewedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=\(apiKey)")
//
//    let session = URLSession.shared
//
//    // запрос до API New York Times.
//    let emailedTask = session.dataTask(with: emailedURL!) { (data, response, error) in
//        if let error = error {
//            print("Ошибка при получении данных о самых электронных статьях: \(error.localizedDescription)")
//            return
//        }
//        // Здесь можно разбирать полученные данные в формате JSON для самых электронных статей.
//    }
//
//    let sharedTask = session.dataTask(with: sharedURL!) { (data, response, error) in
//        if let error = error {
//            print("Ошибка при получении данных о самых популярных статьях: \(error.localizedDescription)")
//            return
//        }
//        // Здесь можно разбирать полученные данные в формате JSON для самых популярных статей.
//    }
//
//    let viewedTask = session.dataTask(with: viewedURL!) { (data, response, error) in
//        if let error = error {
//            print("Ошибка при получении данных о самых просматриваемых статьях: \(error.localizedDescription)")
//            return
//        }
//        // Здесь можно разбирать полученные данные в формате JSON для самых просматриваемых статей.
//    }
//
//    // Запускаем задачи для получения данных.
//    emailedTask.resume()
//    sharedTask.resume()
//    viewedTask.resume()
//}

import Foundation

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
