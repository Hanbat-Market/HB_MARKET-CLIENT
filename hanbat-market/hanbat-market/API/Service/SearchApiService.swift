//
//  SearchApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/27/24.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum SearchApiService {
    
    static func fetchSearchData(itemStatus: String, title: String, itemName: String) -> AnyPublisher<HomeResponse, AFError> {
        print("SearchApiService - fetchSearchData() called")
        
        return ApiClient.shared.session
            .request(SearchRouter.fetchSearchData(itemStatus: itemStatus, title: title, itemName: itemName))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success:
                    print("fetchSearchData request finished")
                case .failure(let error):
                    print("fetchSearchData errorCode: \(String(describing: error.responseCode))")
                    
                    if let data = response.data {
                        let responseBody = String(data: data, encoding: .utf8)
                        print("fetchSearchData responseBody: \(responseBody ?? "No data")")
                    }
                }
            })
            .publishDecodable(type: HomeResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}
