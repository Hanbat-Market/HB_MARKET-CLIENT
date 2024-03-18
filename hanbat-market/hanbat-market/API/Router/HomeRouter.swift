//
//  HomeRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Foundation
import Alamofire

// 홈 라우터
// 게시글 Read
enum HomeRouter: URLRequestConvertible {
    
    case loadHome
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .loadHome: return "/api"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loadHome: return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request.httpBody = try JSONEncoding.default.encode(request).httpBody
        
        return request
    }
}
