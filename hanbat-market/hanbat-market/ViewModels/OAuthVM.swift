//
//  OAuthVM.swift
//  hanbat-market
//
//  Created by dongs on 4/7/24.
//

import SwiftUI
import Alamofire
import Combine
import WebKit
import JWTDecode
import FirebaseMessaging

class OAuthVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var isWebViewPresented = false
    @Published var isLoggedIn = false
    
    func openWebView() {
        isWebViewPresented = true
    }
    
    func saveAccessTokenCookie(accessToken: String) {
        
        do {
            let accessJwt = try decode(jwt: accessToken)
            
            UserDefaults.standard.set(accessJwt.body["UUID"], forKey: "uuid")
            
            if let fcmToken = Messaging.messaging().fcmToken,
               let userUUID = (accessJwt.body["UUID"] as? String){
                saveFcmToken(uuid: userUUID, fcmToken: fcmToken)
            }
        } catch {
            print("JWT Token Error - \(error)")
        }
        
        UserDefaults.standard.set(accessToken, forKey: "Authorization")
        self.isLoggedIn = true
        self.isWebViewPresented = false
        OAuthManager.shared.isLoggedIn = true
    }
    
    private func saveFcmToken(uuid: String, fcmToken: String) {
        AuthApiService.saveFcmToken(targetMemberUuid: uuid, fcmToken: fcmToken)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("saveFcmToken request finished: \(completion)")
                case .failure(let error):
                    print("saveFcmToken errorCode: \(String(describing: error.responseCode))")
                    print("saveFcmToken errorDes: \(String(describing: error.localizedDescription))")
                }
            } receiveValue: { receivedUser in
                print("saveFcmToken receivedUser: \(receivedUser)")
            }.store(in: &subscription)
    }
}
