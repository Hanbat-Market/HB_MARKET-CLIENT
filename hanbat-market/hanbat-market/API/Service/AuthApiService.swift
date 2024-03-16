//
//  AuthApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum AuthApiService {
//    static func login(email: String, password: String) ->
    
    static func register(email: String, password: String, phoneNumber: String, nickname: String) -> AnyPublisher<AuthRegisterResponse, AFError> {
        print("AuthApiService - register() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(email: email, password: password, phoneNumber: phoneNumber, nickname: nickname))
            .publishDecodable(type: AuthRegisterResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}
