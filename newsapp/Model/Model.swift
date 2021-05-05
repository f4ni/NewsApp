//
//  Model.swift
//  newsapp
//
//  Created by f4ni on 1.05.2021.
//

import Foundation

struct NBundle: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [News]
}

struct News: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
}

struct Source: Codable {
    let id: String?
    let name: String?
}
