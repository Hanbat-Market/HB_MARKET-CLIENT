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
    case logout(uuid: String)
    case saveFcmToken(targetMemberUuid: String, fcmToken: String)
    case verifyStudent(mail: String, memberUuid: String)
    case matchStudent(memberUuid: String, number: String)
    case confirmStudent(memberUuid: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "/api/members/new"
        case .login: return "/api/members/login"
        case .logout: return "/api/members/logout"
        case .saveFcmToken: return "/api/fcm/save"
        case .verifyStudent: return "/api/verification"
        case .matchStudent: return "/api/verification/match"
        case .confirmStudent: return "/api/verification/confirm"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        case .login: return .post
        case .logout: return .post
        case .saveFcmToken: return .post
        case .verifyStudent: return .post
        case .matchStudent: return .post
        case .confirmStudent: return .post
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
            
        case let .logout(uuid):
            var params = Parameters()
            params["uuid"] = uuid
            return params
            
        case let .saveFcmToken(targetMemberUuid, fcmToken):
            var params = Parameters()
            params["targetMemberUuid"] = targetMemberUuid
            params["fcmToken"] = fcmToken
            return params
            
        case let .verifyStudent(mail, memberUuid):
            var params = Parameters()
            params["mail"] = mail
            params["memberUuid"] = memberUuid
            return params
            
        case let .matchStudent(memberUuid, number):
            var params = Parameters()
            params["memberUuid"] = memberUuid
            params["number"] = number
            return params
            
        case let .confirmStudent(memberUuid):
            var params = Parameters()
            params["memberUuid"] = memberUuid
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
