//
//  SaleApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI
import Alamofire
import Combine

// 인증 관련 api 호출
enum SaleApiService {
    
    static func register(title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage]) -> AnyPublisher<SaleResponseModel, AFError> {
        print("SaleApiService - register() called")
        
        return ApiClient.shared.session
            .request(SaleRouter.register(title: title, price: price, itemName: itemName, description: description, tradingPlace: tradingPlace, selectedImages: selectedImages))
        
            .validate(statusCode: 200..<300)
            .publishDecodable(type: SaleResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
}
