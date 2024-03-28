//
//  TradeApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import SwiftUI
import Alamofire
import Combine

enum TradeApiService {
    
    static func postTradeReservation(purchaserNickname: String, articleId: Int, transactionAppointmentDateTime: String, reservationPlace: String) -> AnyPublisher<TradeReservationResponse, AFError> {
        return ApiClient.shared.session
            .request(TradeRouter.postTradeReservation(purchaserNickname: purchaserNickname, articleId: articleId, transactionAppointmentDateTime: transactionAppointmentDateTime, reservationPlace: reservationPlace))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: TradeReservationResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}

