//
//  PreemptionRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/24/24.
//

import Foundation
import SwiftUI
import Alamofire

// 인증 라우터
// 회원가입, 로그인
enum PreemptionRouter: URLRequestConvertible {
    
    case fetchPreemptionItems
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .fetchPreemptionItems: return "/api/preemptionItems"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPreemptionItems: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fetchPreemptionItems: return [:]
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

