//
//  OAuthVM.swift
//  hanbat-market
//
//  Created by dongs on 4/7/24.
//

import SwiftUI
import WebKit
import JWTDecode

class OAuthVM: ObservableObject {
    @Published var isWebViewPresented = false
    @Published var isLoggedIn = false
    
    func openWebView() {
        isWebViewPresented = true
    }
    
    func saveAccessTokenCookie(accessToken: String) {
        
        do {
            let accessJwt = try decode(jwt: accessToken)
            
            UserDefaults.standard.set(accessJwt.body["UUID"], forKey: "uuid")
        } catch {
            print("JWT Token Error - \(error)")
        }
        
        UserDefaults.standard.set(accessToken, forKey: "Authorization")
        self.isLoggedIn = true
        self.isWebViewPresented = false
        OAuthManager.shared.isLoggedIn = true
    }
}
