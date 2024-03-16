//
//  AuthRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인, 세션 갱신
enum AuthRouter : URLRequestConvertible {
    
    case register(email: String, password: String, phoneNumber: String, nickname: String)
    case login(email: String, password: String)
//    case tokenRefresh
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "api/members/new"
        case .login: return "api/login"
        default: return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        case .login: return .get
        default: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            return params
            
        case let .register(email, password, phoneNumber, nickname):
            var params = Parameters()
            params["mail"] = email
            params["passwd"] = password
            params["phoneNumber"] = phoneNumber
            params["nickname"] = nickname
            return params
            
//        case .tokenRefresh:
//            var params = Parameters()
//            params["refresh_token"] =
//            return params
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