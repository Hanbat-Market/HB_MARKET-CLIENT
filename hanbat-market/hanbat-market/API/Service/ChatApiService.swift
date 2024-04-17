//
//  ChatApiService.swift
//  hanbat-market
//
//  Created by dongs on 4/14/24.
//

import Foundation
import Alamofire
import Combine
import LDSwiftEventSource

enum ChatApiService {
    
    static func postChat(msg: String, sender: String, receiver: String, roomNum: Int) -> AnyPublisher<ChatResponse, AFError> {
        print("ChatApiService - postChat() called")
        
        return ApiClient.shared.session
            .request(ChatRouter.postChat(msg: msg, sender: sender, receiver: receiver, roomNum: roomNum))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success:
                    print("postChat request finished")
                case .failure(let error):
                    print("postChat errorCode: \(String(describing: error.responseCode))")
                    
                    if let data = response.data {
                        let responseBody = String(data: data, encoding: .utf8)
                        print("postChat responseBody: \(responseBody ?? "No data")")
                    }
                }
            })
            .publishDecodable(type: ChatResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func fetchChatRooms(senderId: String) -> AnyPublisher<[ChatRoomsResponse], AFError> {
        print("ChatApiService - fetchChatRooms() called")
        
        return ApiClient.shared.session
            .request(ChatRouter.fetchChatRooms(senderId: senderId))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success:
                    print("fetchChatRooms request finished")
                case .failure(let error):
                    print("fetchChatRooms errorCode: \(String(describing: error.responseCode))")
                    
                    if let data = response.data {
                        let responseBody = String(data: data, encoding: .utf8)
                        print("fetchChatRooms responseBody: \(responseBody ?? "No data")")
                    }
                }
            })
            .publishDecodable(type: [ChatRoomsResponse].self)
            .value()
            .eraseToAnyPublisher()
    }
}
