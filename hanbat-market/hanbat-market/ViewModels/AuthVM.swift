//
//  AuthVM.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire
import Combine

class AuthVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: AuthRegisterData? = nil
    @Published var loggedLogInUser: String? = nil
    
    var registraionSuccess = PassthroughSubject<(), Never>()
    var loginSuccess = PassthroughSubject<(), Never>()
    
    func register(email: String, password: String, phoneNumber: String, nickname: String){
        print("AuthVM: register() called")
        AuthApiService.register(email: email, password: password, phoneNumber: phoneNumber, nickname: nickname)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("AuthVM completion: \(completion)")
            } receiveValue: { [weak self] receivedUser in
                print("AuthVM receivedUser: \(receivedUser)")
                self?.loggedInUser = receivedUser
                self?.registraionSuccess.send()
            }.store(in: &subscription)
        
    }
    
    func login(email: String, password: String){
        print("AuthVM: login() called")
        AuthApiService.login(email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("AuthVM completion: \(completion)")
                switch completion {
                case .finished:
                    print("Login request finished")
                case .failure(let error):
                    print("Login request failed: \(error)")
                }
            } receiveValue: { [weak self] receivedUser in
                print("AuthVM receivedUser: \(receivedUser)")
                self?.loggedLogInUser = receivedUser
                self?.loginSuccess.send()
                
                print("ok?:", receivedUser == "ok")
                
                if receivedUser == "ok"{
                    if let sessionCookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "JSESSIONID" }) {
                        print(sessionCookie)
                        SessionManager.shared.saveSessionCookie(cookie: sessionCookie)
                    }
                }
            }.store(in: &subscription)
    }
}
