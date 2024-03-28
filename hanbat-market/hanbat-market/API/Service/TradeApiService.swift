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
    
    static func postTradeReservation(memberNickname: String, articleId: Int, transactionAppointmentDateTime: String) -> AnyPublisher<CommonResponseModel, AFError> {
        return ApiClient.shared.session
            .request(TradeRouter.postTradeReservation(memberNickname: memberNickname, articleId: articleId, transactionAppointmentDateTime: transactionAppointmentDateTime))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
}

