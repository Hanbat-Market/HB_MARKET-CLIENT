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
    
    static func register(email: String, password: String, phoneNumber: String, nickname: String) -> AnyPublisher<AuthRegisterData, AFError> {
        print("AuthApiService - register() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(email: email, password: password, phoneNumber: phoneNumber, nickname: nickname))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: AuthRegisterResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
    static func login(email: String, password: String) -> AnyPublisher<String, AFError> {
        print("AuthApiService - login() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.login(email: email, password: password))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: AuthLoginResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
}
