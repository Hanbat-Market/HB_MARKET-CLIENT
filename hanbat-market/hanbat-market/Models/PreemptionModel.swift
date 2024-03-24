//
//  PreemptionModel.swift
//  hanbat-market
//
//  Created by dongs on 3/24/24.
//

import Foundation

struct PreemptionResponse: Codable {
    let data : PreemptionModel
}

struct PreemptionModel: Codable {
    let preemptionItemSize: Int
    let preemptionItemDtos: [PreemptionItemModel]
}

struct PreemptionItemModel: Codable, Identifiable {
    let id: Int
    let seller: String
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let thumbnailFilePath: String
    let createdAt: String
    let itemStatus: String
    let preemptionSize: Int
    let preemptionItemStatus: String
}
