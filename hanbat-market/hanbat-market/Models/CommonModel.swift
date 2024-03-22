//
//  CommonModel.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation

struct CommonModel: Codable {
    let status: Int
    let errorCode: String
    let errorMessage: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case errorCode
        case errorMessage = "message"
    }
}

struct CommonArticleModel: Codable {
    let data: String
}
