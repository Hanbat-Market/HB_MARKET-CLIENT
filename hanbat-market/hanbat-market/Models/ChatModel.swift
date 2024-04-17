//
//  ChatModel.swift
//  hanbat-market
//
//  Created by dongs on 4/14/24.
//

import Foundation

struct ChatResponse: Codable {
    let id: String
    let msg: String
    let sender: String
    let senderNickName: String
    let receiver: String
    let receiverNickName: String
    let roomNum: Int
    let createdAt: String
}

struct ChatRoomsResponse: Codable {
    let senderUuid: String
    let receiverUuid: String
    let senderNickname: String
    let receiverNickname: String
    let lastChat: String
    let roomNum: Int
    let createdAt: String
}
