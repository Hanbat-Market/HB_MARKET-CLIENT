//
//  KeychainService.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import Foundation
import Security

struct KeychainService {
    private static let serviceName = "JSESSIONID"
    private static let sessionIDKey = "JSESSIONID"

    static func saveSessionID(_ sessionID: String) {
        guard let data = sessionID.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: sessionIDKey,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let _ = SecItemAdd(query as CFDictionary, nil)
    }

    static func loadSessionID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: sessionIDKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else { return nil }

        return String(data: data, encoding: .utf8)
    }

    static func deleteSessionID() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: sessionIDKey
        ]

        let _ = SecItemDelete(query as CFDictionary)
    }
}

