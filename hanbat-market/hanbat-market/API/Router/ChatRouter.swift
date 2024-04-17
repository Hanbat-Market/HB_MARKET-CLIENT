//
//  ChatRouter.swift
//  hanbat-market
//
//  Created by dongs on 4/14/24.
//

import Foundation
import Alamofire

enum ChatRouter: URLRequestConvertible {
    
    case postChat(msg: String, sender: String, receiver: String, roomNum: Int)
    case fetchChatRooms(senderId: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .postChat: return "/chat"
        case let .fetchChatRooms(senderId): return "/chat/rooms/\(senderId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postChat: return .post
        case .fetchChatRooms: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .postChat(msg, sender, receiver, roomNum):
            var params = Parameters()
            
            params["msg"] = msg
            params["sender"] = sender
            params["receiver"] = receiver
            params["roomNum"] = roomNum
            
            return params
        case .fetchChatRooms: return [:]
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

