//
//  ProfileRouter.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import SwiftUI
import Alamofire

enum ProfileRouter: URLRequestConvertible {
    
    case fetchProfile(uuid: String)
    case putProfileImage(imageFile: UIImage, uuid: String)
    case putProfileNickname(uuid: String, nickname: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case let .fetchProfile(uuid): return "/api/profiles/\(uuid)"
        case .putProfileImage: return "/api/profiles/image"
        case .putProfileNickname: return "/api/profiles/nickname"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProfile: return .get
        case .putProfileImage: return .put
        case .putProfileNickname: return .put
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fetchProfile: return [:]
        case let .putProfileImage(imageFile, uuid):
            var params = Parameters()
            
            params["imageFile"] = imageFile
            params["uuid"] = uuid
            
            return params
        case let .putProfileNickname(uuid, nickname):
            var params = Parameters()
            
            params["uuid"] = uuid
            params["nickName"] = nickname
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        if method != .get {
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        
        return request
    }
}
