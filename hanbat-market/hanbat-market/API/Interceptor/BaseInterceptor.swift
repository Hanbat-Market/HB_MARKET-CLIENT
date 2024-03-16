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
        
        // 헤더 부분 삽입
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accpet")
        
        completion(.success(request))
    }
}
