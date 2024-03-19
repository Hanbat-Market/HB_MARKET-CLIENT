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
    @Published var loginFailed: Bool = false
    
    var registraionSuccess = PassthroughSubject<(), Never>()
    var loginSuccess = PassthroughSubject<(), Never>()
    
    func register(email: String, password: String, phoneNumber: String, nickname: String){
        print("AuthVM: register() called")
        AuthApiService.register(email: email, password: password, phoneNumber: phoneNumber, nickname: nickname)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("register completion: \(completion)")
                switch completion {
                case .finished:
                    print("register request finished")
                case .failure(let error):
                    print("register errorCode: \(String(describing: error.responseCode))")
                    print("register errorDes: \(String(describing: error.localizedDescription))")
                }
            } receiveValue: { [weak self] receivedUser in
                print("register receivedUser: \(receivedUser)")
                self?.loggedInUser = receivedUser
                self?.registraionSuccess.send()
            }.store(in: &subscription)
        
    }
    
    func login(email: String, password: String){
        print("AuthVM: login() called")
        AuthApiService.login(email: email, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("Login request finished: \(completion)")
                case .failure(let error):
                    print("Login errorCode: \(String(describing: error.responseCode))")
                    print("Login errorDes: \(String(describing: error.localizedDescription))")
                    self.loginFailed = true
                }
            } receiveValue: { [weak self] receivedUser in
                print("Login receivedUser: \(receivedUser)")
                self?.loggedLogInUser = receivedUser
                self?.loginSuccess.send()
                
                if receivedUser == "ok"{
                    if let sessionCookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "JSESSIONID" }) {
                        print("쿠키 저장: ", sessionCookie)
                        SessionManager.shared.saveSessionCookie(cookie: sessionCookie)
                    }
                }
            }.store(in: &subscription)
    }
    
    func logout(){
        print("AuthVM: logout() called")
        AuthApiService.logout()
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("logout request finished: \(completion)")
                case .failure(let error):
                    print("logout errorCode: \(String(describing: error.responseCode))")
                    print("logout errorDes: \(String(describing: error.localizedDescription))")
                    self.loginFailed = true
                }
            } receiveValue: { receivedUser in
                print("logout receivedUser: \(receivedUser)")
                
                if receivedUser == "ok"{
                    SessionManager.shared.logout()
                }
            }.store(in: &subscription)
    }
}
