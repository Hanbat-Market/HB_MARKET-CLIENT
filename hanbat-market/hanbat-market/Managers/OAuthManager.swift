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
    
    var subscription = Set<AnyCancellable>()
    
    func checkTokenExpiration() {
        let accessToken = UserDefaults.standard.string(forKey: "Authorization")
        
        if let accessToken = accessToken,
           !isTokenExpired(accessToken) {
            
            do {
                let accessJwt = try decode(jwt: accessToken)
                
                userId = "\(String(describing: accessJwt.body["mail"]))"
                
                print("OAuthManager - JWT token body: \(accessJwt.body)")
                
                UserDefaults.standard.set(accessJwt.body["UUID"], forKey: "uuid")
            } catch {
                print("JWT Token Expired Error - \(error)")
                isLoggedIn = false
            }
        } else {
            isLoggedIn = false
        }
        
        print("login - \(isLoggedIn)")
        print(self.getAccessToken())
        print(self.getUUID())
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
    
    func getAccessToken() -> String {
        let accessToken = UserDefaults.standard.string(forKey: "Authorization") ?? ""
        return accessToken
    }
    
    func getUUID() -> String {
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        return uuid
    }
    
    func oauthLogout(uuid: String) {
        AuthApiService.logout(uuid: uuid)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("logout request finished: \(completion)")
                    self.isLoggedIn = false
                    UserDefaults.standard.removeObject(forKey: "Authorization")
                    UserDefaults.standard.removeObject(forKey: "uuid")
                case .failure(let error):
                    print("logout errorCode: \(String(describing: error.responseCode))")
                    print("logout errorDes: \(String(describing: error.localizedDescription))")
                }
            } receiveValue: { receivedUser in
                print("logout receivedUser: \(receivedUser)")
                
            }.store(in: &subscription)
    }
    
    func resetUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

