//
//  SessionManager.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    private let userDefaults = UserDefaults.standard
    
    @Published var isLoggedIn = false
    
    func saveSessionCookie(cookie: HTTPCookie) {
        let sessionCookieData = AuthCookieData(name: cookie.name,
                                               value: cookie.value,
                                               domain: cookie.domain,
                                               path: cookie.path,
                                               expiresDate: cookie.expiresDate)
        
        print("sessionCookieData: ", sessionCookieData)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sessionCookieData) {
            userDefaults.set(encoded, forKey: "sessionCookieData")
        }
    }
    
    func checkSessionCookie() {
        
        if loadSessionCookie() != nil{
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        print("login - \(isLoggedIn)")
    }
    
    func loadSessionCookie() -> HTTPCookie? {
        guard let savedData = userDefaults.data(forKey: "sessionCookieData"),
              let sessionCookieData = try? JSONDecoder().decode(AuthCookieData.self, from: savedData) else {
            return nil
        }
        
        let cookieProperties: [HTTPCookiePropertyKey: Any] = [
            .name: sessionCookieData.name,
            .value: sessionCookieData.value,
            .domain: sessionCookieData.domain,
            .path: sessionCookieData.path,
            .expires: sessionCookieData.expiresDate ?? Date().addingTimeInterval(3600), // Set default expiration time if not provided
            .secure: true,
        ]
        
        print(sessionCookieData)
        
        return HTTPCookie(properties: cookieProperties)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "sessionCookieData")
        
        isLoggedIn = false
    }
}
