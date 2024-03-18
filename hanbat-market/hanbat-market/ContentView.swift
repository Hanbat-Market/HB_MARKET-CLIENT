//
//  ContentView.swift
//  hanbat-market
//
//  Created by dongs on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    @StateObject var authManager = SessionManager.shared
    
    var body: some View {
        if authManager.isLoggedIn {
            TabView(selection: $selection){
                HomeView()
                    .tabItem {
                        VStack(spacing: 4){
                            Image(systemName: "house.fill")
                            Text("홈")
                        }.padding(.vertical, 10)
                    }
                    .tag(0)
                
                ChatView()
                    .tabItem {
                        Image(systemName: "ellipsis.bubble")
                        Spacer().frame(height: 4)
                        Text("채팅")
                        Spacer().frame(height: 10)
                    }
                    .tag(1)
                
                HeartView()
                    .tabItem {
                        Image(systemName: "heart")
                        Spacer().frame(height: 4)
                        Text("찜")
                        Spacer().frame(height: 10)
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Spacer().frame(height: 4)
                        Text("프로필")
                        Spacer().frame(height: 10)
                    }
                    .tag(3)
            }
            .accentColor(CommonStyle.MAIN_COLOR)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
