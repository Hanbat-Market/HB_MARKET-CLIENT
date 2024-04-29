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
    @Published var registerFailed: Bool = false
    
    var registraionSuccess = PassthroughSubject<(), Never>()
    var loginSuccess = PassthroughSubject<(), Never>()
    
    func register(email: String, password: String, nickname: String){
        print("AuthVM: register() called")
        AuthApiService.register(email: email, password: password, nickname: nickname)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("register completion: \(completion)")
                switch completion {
                case .finished:
                    print("register request finished")
                case .failure(let error):
                    print("register errorCode: \(String(describing: error.responseCode))")
                    print("register errorDes: \(String(describing: error.localizedDescription))")
                    self.registerFailed = true
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
    
    func logout(uuid: String){
        print("AuthVM: logout() called")
        AuthApiService.logout(uuid: uuid)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("logout request finished: \(completion)")
                case .failure(let error):
                    print("logout errorCode: \(String(describing: error.responseCode))")
                    print("logout errorDes: \(String(describing: error.localizedDescription))")
                }
            } receiveValue: { receivedUser in
                print("logout receivedUser: \(receivedUser)")
            }.store(in: &subscription)
    }
    
    @Published var verifyStudentResponse: CommonResponseModel? = nil
    var verifyStudentSuccess = PassthroughSubject<(), Never>()
    @Published var verifyStudentFailed: Bool = false
    
    func verifyStudent(mail: String, memberUuid: String){
        print("AuthVM: verifyStudent() called")
        AuthApiService.verifyStudent(mail: mail, memberUuid: memberUuid)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("verifyStudent request finished: \(completion)")
                case .failure(let error):
                    print("verifyStudent errorCode: \(String(describing: error.responseCode))")
                    print("verifyStudent errorDes: \(String(describing: error.localizedDescription))")
                    self.verifyStudentFailed = true
                }
            } receiveValue: { [weak self] receivedUser in
                print("verifyStudent receivedUser: \(receivedUser)")
                self?.verifyStudentResponse = receivedUser
                self?.verifyStudentSuccess.send()
            }.store(in: &subscription)
    }
    
    @Published var matchStudentResponse: CommonResponseModel? = nil
    @Published var matchStudentSuccess: Bool = false
    @Published var matchStudentFailed: Bool = false
    
    func matchStudent(memberUuid: String, number: String){
        print("AuthVM: matchStudent() called")
        AuthApiService.matchStudent(memberUuid: memberUuid, number: number)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("matchStudent request finished: \(completion)")
                    self.matchStudentSuccess = true
                case .failure(let error):
                    print("matchStudent errorCode: \(String(describing: error.responseCode))")
                    print("matchStudent errorDes: \(String(describing: error.localizedDescription))")
                    
                    self.matchStudentFailed = true
                }
            } receiveValue: { [weak self] receivedUser in
                print("matchStudent receivedUser: \(receivedUser)")
                self?.matchStudentResponse = receivedUser
                
            }.store(in: &subscription)
    }
    
    @Published var confirmStudentResponse: CommonResponseModel? = nil
    @Published var confirmStudentSuccess: Bool = false
    @Published var confirmStudentFailed: Bool = false
    
    func confirmStudent(memberUuid: String){
        print("AuthVM: confirmStudent() called")
        AuthApiService.confirmStudent(memberUuid: memberUuid)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("confirmStudent request finished: \(completion)")
                    self.confirmStudentSuccess = true
                case .failure(let error):
                    print("confirmStudent errorCode: \(String(describing: error.responseCode))")
                    print("confirmStudent errorDes: \(String(describing: error.localizedDescription))")
                    self.confirmStudentFailed = true
                }
            } receiveValue: { [weak self] receivedUser in
                print("confirmStudent receivedUser: \(receivedUser)")
                self?.confirmStudentResponse = receivedUser
            }.store(in: &subscription)
    }
}
