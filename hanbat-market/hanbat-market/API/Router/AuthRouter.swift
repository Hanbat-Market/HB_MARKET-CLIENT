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
    
    case register(email: String, password: String, nickname: String)
    case login(email: String, password: String)
    case logout
    case saveFcmToken(targetMemberUuid: String, fcmToken: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "/api/members/new"
        case .login: return "/api/members/login"
        case .logout: return "/api/members/logout"
        case .saveFcmToken: return "/api/fcm/save"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        case .login: return .post
        case .logout: return .post
        case .saveFcmToken: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["mail"] = email
            params["passwd"] = password
            return params
            
        case let .register(email, password, nickname):
            var params = Parameters()
            params["mail"] = email
            params["passwd"] = password
            params["nickname"] = nickname
            return params
            
        case .logout:
            return Parameters()
            
        case let .saveFcmToken(targetMemberUuid, fcmToken):
            var params = Parameters()
            params["targetMemberUuid"] = targetMemberUuid
            params["fcmToken"] = fcmToken
            return params
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
