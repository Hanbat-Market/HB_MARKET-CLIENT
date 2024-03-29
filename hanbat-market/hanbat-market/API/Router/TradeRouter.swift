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
    case postTradeComplete(articleId: Int, purchaserNickname: String)
    case postTradeCancel(articleId: Int, purchaserNickname: String, requestMemberNickname: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .postTradeReservation: return "/api/trade/reservation"
        case .postTradeComplete: return "/api/trade/complete"
        case .postTradeCancel: return "/api/trade/cancel"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postTradeReservation: return .post
        case .postTradeComplete: return .post
        case .postTradeCancel: return .post
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
        case let .postTradeComplete(articleId, purchaserNickname):
            var params = Parameters()
            
            params["articleId"] = articleId
            params["purchaserNickname"] = purchaserNickname
            
            return params
        case let .postTradeCancel(articleId, purchaserNickname, requestMemberNickname):
            var params = Parameters()
            
            params["articleId"] = articleId
            params["purchaserNickname"] = purchaserNickname
            params["requestMemberNickname"] = requestMemberNickname
            
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


