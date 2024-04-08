//
//  OAuthManager.swift
//  hanbat-market
//
//  Created by dongs on 4/8/24.
//

import SwiftUI
import Alamofire
import Combine
import JWTDecode

class OAuthManager: ObservableObject {
    
    static let shared = OAuthManager()
    
    @Published var isLoggedIn = true
    @Published var userId = ""
    
    func checkTokenExpiration() {
        let accessToken = UserDefaults.standard.string(forKey: "Authorization")
        
        if let accessToken = accessToken,
           !isTokenExpired(accessToken) {
            
            do {
                let accessJwt = try decode(jwt: accessToken)
                
                userId = "\(String(describing: accessJwt.body["mail"]))"
                
                print("OAuthManager - JWT token body: \(accessJwt.body)")
            } catch {
                print("JWT Token Expired Error - \(error)")
                isLoggedIn = false
            }
        } else {
            isLoggedIn = false
        }
        
        print("login - \(isLoggedIn)")
    }
    
    func isTokenExpired(_ token: String) -> Bool {
        
        do {
            let jwt = try decode(jwt: token)
            
            if let expiresAt = jwt.expiresAt {
                let currentTime = Date()
                if currentTime > expiresAt {
                    return true
                }
            }
        } catch {
            print("OAuthManager - JWT Token Expired Error: \(error)")
            isLoggedIn = false
        }
        
        return false
    }
    
    func oauthLogout() {
        UserDefaults.standard.removeObject(forKey: "Authorization")
        
        isLoggedIn = false
    }
    
    func resetUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

