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
    let uuid: String?
    let title: String
    let description: String
    let tradingPlace: String
    let itemStatus: String
    let itemName: String
    let price: Int
    let nickname: String
    let filePaths: [String]
    let createdAt: String
    let preemptionItemStatus: String
    let preemptionItemSize: Int
}

struct ArticlePreemptionResponse: Codable {
    let data: String
}
