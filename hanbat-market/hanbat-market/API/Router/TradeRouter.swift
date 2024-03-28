//
//  TradeRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import Foundation
import SwiftUI
import Alamofire

enum TradeRouter: URLRequestConvertible {
    
    case postTradeReservation(purchaserNickname: String, articleId: Int, transactionAppointmentDateTime: String, reservationPlace: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .postTradeReservation: return "/api/trade/reservation"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postTradeReservation: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .postTradeReservation(purchaserNickname, articleId, transactionAppointmentDateTime, reservationPlace):
            var params = Parameters()
            
            params["purchaserNickname"] = purchaserNickname
            params["articleId"] = articleId
            params["transactionAppointmentDateTime"] = transactionAppointmentDateTime
            params["reservationPlace"] = reservationPlace
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        if method == .post {
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        
        return request
    }
}


