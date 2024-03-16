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
    
    @Published var loggedInUser: AuthRegisterModel? = nil
    
    func register(email: String, password: String, phoneNumber: String, nickname: String){
        print("AuthVM: register() called")
        AuthApiService.register(email: email, password: password, phoneNumber: phoneNumber, nickname: nickname)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("AuthVM completion: \(completion)")
            } receiveValue: { [weak self] receivedUser in
                print("AuthVM receivedUser: \(receivedUser)")
                self?.loggedInUser = receivedUser
            }.store(in: &subscription)

    }
}
