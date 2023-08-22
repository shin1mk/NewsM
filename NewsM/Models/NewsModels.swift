//
//  NewsModels.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 22.08.2023.
//

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
