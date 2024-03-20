//
//  HomeModel.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Foundation

struct HomeResponse: Codable {
    let data: HomeArticleResponse
}

struct HomeArticleResponse: Codable {
    let memberPreemptionSize: Int
    let articlesCount: Int
    let articles: [HomeArticleModel]
}

struct HomeArticleModel: Codable {
    let id: Int
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let memberNickname: String
    let thumbnailFilePath: String
    let createdAt: String
}
