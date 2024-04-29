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
    
    static func register(email: String, password: String, nickname: String) -> AnyPublisher<AuthRegisterData, AFError> {
        print("AuthApiService - register() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(email: email, password: password, nickname: nickname))
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
    
    static func logout(uuid: String) -> AnyPublisher<String, AFError> {
        print("AuthApiService - logout() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.logout(uuid: uuid))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
    static func saveFcmToken(targetMemberUuid: String, fcmToken: String) -> AnyPublisher<String, AFError> {
        print("AuthApiService - saveFcmToken() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.saveFcmToken(targetMemberUuid: targetMemberUuid, fcmToken: fcmToken))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
    static func verifyStudent(mail: String, memberUuid: String) -> AnyPublisher<CommonResponseModel, AFError> {
        print("AuthApiService - verifyStudent() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.verifyStudent(mail: mail, memberUuid: memberUuid))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func matchStudent(memberUuid: String, number: String) -> AnyPublisher<CommonResponseModel, AFError> {
        print("AuthApiService - matchStudent() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.matchStudent(memberUuid: memberUuid, number: number))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func confirmStudent(memberUuid: String) -> AnyPublisher<CommonResponseModel, AFError> {
        print("AuthApiService - confirmStudent() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.confirmStudent(memberUuid: memberUuid))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .eraseToAnyPublisher()
    }
}
