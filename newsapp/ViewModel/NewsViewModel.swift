//
//  NewsViewModel.swift
//  newsapp
//
//  Created by f4ni on 2.05.2021.
//

import Foundation

struct NewsViewModel: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?
    
    init(news: News) {
        self.title = news.title
        self.author = "📝 Autor: \(news.author ?? "N/A")"
        self.urlToImage = URL(string: news.urlToImage ?? "")
        self.description = news.description
        self.publishedAt = "📅 \(news.publishedAt?.prefix(10) ?? "")"
        self.url = URL(string: news.url ?? "")
        self.content = news.content
        self.source = news.source
    }
}
