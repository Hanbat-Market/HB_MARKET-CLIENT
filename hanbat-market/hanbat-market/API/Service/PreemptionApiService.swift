//
//  PreemptionApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/24/24.
//

import SwiftUI
import Alamofire
import Combine

enum PreemptionApiService {
    
    static func fetchPreemptionItems() -> AnyPublisher<PreemptionModel, AFError> {
        return ApiClient.shared.session
            .request(PreemptionRouter.fetchPreemptionItems)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PreemptionResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
}

