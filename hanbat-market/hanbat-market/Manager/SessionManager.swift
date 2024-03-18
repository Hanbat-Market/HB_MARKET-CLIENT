//
//  UserDefaultManager.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Alamofire
import Combine

class SessionManager {
    static let shared = SessionManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(username: String, password: String) {
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request("https://your-server.com/login", method: .post, parameters: parameters)
            .publishDecodable(type: LoginResponse.self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                // Handle completion (e.g., error)
                switch completion {
                case .finished:
                    print("Login request finished")
                case .failure(let error):
                    print("Login request failed: \(error)")
                }
            }, receiveValue: { response in
                // Handle successful login response
                if let sessionCookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "session" }) {
                    // Save session cookie
                    self.saveSessionCookie(cookie: sessionCookie)
                }
            })
            .store(in: &cancellables)
    }
    
    private func saveSessionCookie(cookie: HTTPCookie) {
        // Save session cookie to UserDefaults
    }
}
