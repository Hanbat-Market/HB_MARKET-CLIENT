//
//  ContentView.swift
//  hanbat-market
//
//  Created by dongs on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authManager = SessionManager.shared
    
    var body: some View {
        if authManager.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
