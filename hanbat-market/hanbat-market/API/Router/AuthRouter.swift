//
//  AuthRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인
enum AuthRouter: URLRequestConvertible {
    
    case register(email: String, password: String, phoneNumber: String, nickname: String)
    case login(email: String, password: String)
    case logout
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "/api/members/new"
        case .login: return "/api/members/login"
        case .logout: return "/api/members/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        case .login: return .post
        case .logout: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["mail"] = email
            params["passwd"] = password
            return params
            
        case let .register(email, password, phoneNumber, nickname):
            var params = Parameters()
            params["mail"] = email
            params["passwd"] = password
            params["phoneNumber"] = phoneNumber
            params["nickname"] = nickname
            return params
            
        case .logout:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}
