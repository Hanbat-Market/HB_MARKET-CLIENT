//
//  TradeModel.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import Foundation

struct TradeReservationResponse: Codable {
    let data: TradeReservationModel
}

struct TradeReservationModel: Codable {
    let tradeId: Int
}
