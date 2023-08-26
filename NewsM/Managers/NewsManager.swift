//
//  NewsManager.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//
// FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl

import Foundation

final class NewsManager {
    static let shared = NewsManager()
    private let apiKey = "FmT19AaabNgeLfhi0HD0pHW9NWwXcNKl"
    //MARK: Fetch articles
    private func fetchArticles(from endpoint: String, completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/\(endpoint)/30.json?api-key=\(apiKey)") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let results = json["results"] as? [[String: Any]] {
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
                                                          mediaMetadata: mediaMetadata,
                                                          isFavorite: false)
                                parsedArticles.append(article)
                            }
                        }
                        completion(parsedArticles, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    // most emailed
    func fetchEmailedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        fetchArticles(from: "emailed", completion: completion)
    }
    // most shared
    func fetchSharedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        fetchArticles(from: "shared", completion: completion)
    }
    // most viewed
    func fetchViewedArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        fetchArticles(from: "viewed", completion: completion)
    }
}
