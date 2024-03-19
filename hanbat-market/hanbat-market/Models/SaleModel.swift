//
//  SaleModel.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import Foundation

struct SaleRequest: Codable {
    let imageFiles: [String]
    let articleCreateRequestDto : SaleModel
}

struct SaleModel: Codable {
    let title: String
    let price: Int
    let itemName: String
    let description: String
    let tradingPlace: String
}
