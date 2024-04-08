//
//  hanbat_marketApp.swift
//  hanbat-market
//
//  Created by dongs on 3/13/24.
//

import SwiftUI

@main
struct hanbat_marketApp: App {    
    
    @StateObject var authManager = SessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OAuthVM())
                .onAppear(){
                    authManager.checkSessionCookie()
                }
        }
    }
}
