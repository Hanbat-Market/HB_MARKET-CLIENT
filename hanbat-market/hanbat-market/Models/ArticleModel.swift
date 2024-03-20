//
//  PostModel.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import Foundation

struct ArticleResponse: Codable {
    let data: ArticleModel
}

struct ArticleModel: Codable {
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let nickname: String
    let filePaths: [String]
    let createdAt: String
    let preemptionItemSize: Int
}
