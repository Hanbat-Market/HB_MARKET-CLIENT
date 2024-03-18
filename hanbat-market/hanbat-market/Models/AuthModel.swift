//
//  AuthModel.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation

struct AuthRegisterModel: Codable {
    let email: String
    let password: String
    let phoneNumber: String
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
        case email = "mail"
        case password = "passwd"
        case phoneNumber
        case nickname
    }
}

struct AuthRegisterResponse: Codable {
    let data: AuthRegisterData
}

struct AuthRegisterData: Codable {
    let mail: String
}

struct AuthLoginResponse: Codable {
    let data: String
}

struct AuthCookieData: Codable {
    let name: String
    let value: String
    let domain: String
    let path: String
    let expiresDate: Date?
}
