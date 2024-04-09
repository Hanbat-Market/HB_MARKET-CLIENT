//
//  BaseInterceptor.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

class BaseInterceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        
        if let accessToken = UserDefaults.standard.string(forKey: "Authorization"){
            let cookie = "Authorization=\(accessToken); "
            request.setValue(cookie, forHTTPHeaderField: "Cookie")
        }
        
        // 헤더 삽입
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        completion(.success(request))
    }
}

class UploadInterceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        
        if let accessToken = UserDefaults.standard.string(forKey: "Authorization"){
            let cookie = "Authorization=\(accessToken); "
            request.setValue(cookie, forHTTPHeaderField: "Cookie")
        }
        
        completion(.success(request))
    }
}

