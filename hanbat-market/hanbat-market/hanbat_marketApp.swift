//
//  hanbat_marketApp.swift
//  hanbat-market
//
//  Created by dongs on 3/13/24.
//

import SwiftUI

@main
struct hanbat_marketApp: App {    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authManager = SessionManager.shared
    @StateObject var oauthManager = OAuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OAuthVM())
                .onAppear(){
                    oauthManager.checkTokenExpiration()
                }
        }
    }
}
