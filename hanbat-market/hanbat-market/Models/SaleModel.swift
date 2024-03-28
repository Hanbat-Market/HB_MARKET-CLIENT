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

struct SaleResponse: Codable {
    let data: SaleResponseModel
}

struct SaleResponseModel: Codable {
    let title: String
    let itemName: String
    let filePaths: [String]
}

struct SalesHistoryResponse: Codable {
    let data: SalesHistoryModel
}

struct PurchaseHistoryResponse: Codable {
    let data: PurchaseHistoryModel
}

struct SalesHistoryModel: Codable {
    let preemptionSize: Int
    let salesDtos: [SaleHistory]
    let reservedDtos: [SaleHistory]
    let completedDtos: [SaleHistory]
}

struct PurchaseHistoryModel: Codable {
    let preemptionSize: Int
    let reservedDtos: [SaleHistory]
    let completedDtos: [SaleHistory]
}

struct SaleHistory: Codable {
    let id: Int
    let tradeId: Int?
    let transactionAppointmentDateTiem: String?
    let seller: String
    let purchaser: String?
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String?
    let itemName: String
    let price: Int
    let thumbnailFilePath: String
    let createdAt: String
    let reservedDate: String?
    let itemStatus: String?
    let preemptionSize: Int?
}

struct SalesHistory: Codable {
    let id: Int
    let seller: String
    let title: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let thumbnailFilePath: String
    let createdAt: String
}

struct ReservedModel: Codable {
    let id: Int
    let tradeId: Int
    let transactionAppointmentDateTiem: String
    let seller: String
    let purchaser: String
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let thumbnailFilePath: String
    let createdAt: String
    let reservedDate: String
}

struct CompletedModel: Codable {
    let id: Int
    let tradeId: Int
    let seller: String
    let purchaser: String
    let title: String
    let description: String
    let tradingPlace: String
    let articleStatus: String
    let itemName: String
    let price: Int
    let thumbnailFilePath: String
    let createdAt: String
    let reservedDate: String
}
