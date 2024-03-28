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
    
    case postTradeReservation(memberNickname: String, articleId: Int, transactionAppointmentDateTime: String)
    
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
        case let .postTradeReservation(memberNickname, articleId, transactionAppointmentDateTime):
            var params = Parameters()
            
            params["memberNickname"] = memberNickname
            params["articleId"] = articleId
            params["transactionAppointmentDateTime"] = transactionAppointmentDateTime
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.method = method
        
        if method == .post {
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        
        return request
    }
}


