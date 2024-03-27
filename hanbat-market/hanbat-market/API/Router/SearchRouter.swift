//
//  SearchRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/27/24.
//

import Foundation
import Alamofire

enum SearchRouter: URLRequestConvertible {
    
    case fetchSearchData(itemStatus: String, title: String, itemName: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .fetchSearchData: return "/api"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSearchData: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .fetchSearchData(itemStatus, title, itemName):
            var params = Parameters()
            
            params["itemStatus"] = itemStatus
            params["title"] = title
            params["itemName"] = itemName
            
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

