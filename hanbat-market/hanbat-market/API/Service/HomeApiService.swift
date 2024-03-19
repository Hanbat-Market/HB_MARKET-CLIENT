//
//  HomeApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum HomeApiService {
    
    static func loadHome() -> AnyPublisher<HomeResponse, AFError> {
        print("HomeApiService - loadHome() called")
        
        return ApiClient.shared.session
            .request(HomeRouter.loadHome)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: HomeResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue
            }
            .eraseToAnyPublisher()
    }
}

