//
//  NewsManager.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//
// FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl

import Foundation

struct NewsArticle {
    let title: String
    let abstract: String
    let url: String
    let publishedDate: String
    var mediaMetadata: [MediaMetadata]
}

struct MediaMetadata {
    let url: String
    let format: String
    let height: Int
    let width: Int
}

final class NewsManager {
    static let shared = NewsManager()
    //MARK: fetchEmailedArticles
    func fetchEmailedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
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
                            var parsedArticles: [NewsArticle] = []
                            for result in results {
                                if let title = result["title"] as? String,
                                   let abstract = result["abstract"] as? String,
                                   let url = result["url"] as? String,
                                   let publishedDate = result["published_date"] as? String,
                                   let mediaArray = result["media"] as? [[String: Any]] {
                                    var mediaMetadata: [MediaMetadata] = []
                                    for media in mediaArray {
                                        if let metadataArray = media["media-metadata"] as? [[String: Any]] {
                                            for metadata in metadataArray {
                                                if let mediaURL = metadata["url"] as? String,
                                                   let mediaFormat = metadata["format"] as? String,
                                                   let mediaHeight = metadata["height"] as? Int,
                                                   let mediaWidth = metadata["width"] as? Int {
                                                    let metadata = MediaMetadata(url: mediaURL, format: mediaFormat, height: mediaHeight, width: mediaWidth)
                                                    mediaMetadata.append(metadata)
                                                }
                                            }
                                        }
                                    }
                                    let article = NewsArticle(title: title,
                                                              abstract: abstract,
                                                              url: url,
                                                              publishedDate: publishedDate,
                                                              mediaMetadata: mediaMetadata)
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
    
    func fetchSharedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
        let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/shared/1.json?api-key=\(apiKey)")
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
                            var parsedArticles: [NewsArticle] = []
                            for result in results {
                                if let title = result["title"] as? String,
                                   let abstract = result["abstract"] as? String,
                                   let url = result["url"] as? String,
                                   let publishedDate = result["published_date"] as? String,
                                   let mediaArray = result["media"] as? [[String: Any]] {
                                    var mediaMetadata: [MediaMetadata] = []
                                    for media in mediaArray {
                                        if let metadataArray = media["media-metadata"] as? [[String: Any]] {
                                            for metadata in metadataArray {
                                                if let mediaURL = metadata["url"] as? String,
                                                   let mediaFormat = metadata["format"] as? String,
                                                   let mediaHeight = metadata["height"] as? Int,
                                                   let mediaWidth = metadata["width"] as? Int {
                                                    let metadata = MediaMetadata(url: mediaURL, format: mediaFormat, height: mediaHeight, width: mediaWidth)
                                                    mediaMetadata.append(metadata)
                                                }
                                            }
                                        }
                                    }
                                    let article = NewsArticle(title: title,
                                                              abstract: abstract,
                                                              url: url,
                                                              publishedDate: publishedDate,
                                                              mediaMetadata: mediaMetadata)
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
    
    func fetchViewedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
        let emailedURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=\(apiKey)")
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
                            var parsedArticles: [NewsArticle] = []
                            for result in results {
                                if let title = result["title"] as? String,
                                   let abstract = result["abstract"] as? String,
                                   let url = result["url"] as? String,
                                   let publishedDate = result["published_date"] as? String,
                                   let mediaArray = result["media"] as? [[String: Any]] {
                                    var mediaMetadata: [MediaMetadata] = []
                                    for media in mediaArray {
                                        if let metadataArray = media["media-metadata"] as? [[String: Any]] {
                                            for metadata in metadataArray {
                                                if let mediaURL = metadata["url"] as? String,
                                                   let mediaFormat = metadata["format"] as? String,
                                                   let mediaHeight = metadata["height"] as? Int,
                                                   let mediaWidth = metadata["width"] as? Int {
                                                    let metadata = MediaMetadata(url: mediaURL, format: mediaFormat, height: mediaHeight, width: mediaWidth)
                                                    mediaMetadata.append(metadata)
                                                }
                                            }
                                        }
                                    }
                                    let article = NewsArticle(title: title,
                                                              abstract: abstract,
                                                              url: url,
                                                              publishedDate: publishedDate,
                                                              mediaMetadata: mediaMetadata)
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
