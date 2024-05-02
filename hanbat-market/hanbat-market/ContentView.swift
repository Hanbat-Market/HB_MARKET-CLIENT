//
//  ContentView.swift
//  hanbat-market
//
//  Created by dongs on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    @StateObject var oauthManager = OAuthManager.shared
    
    @State private var moveToSettingView: Bool = false
    @State private var moveToSearchView: Bool = false
    @State private var showMainView = false
    
    let image = UIImage.gradientImageWithBounds(
        bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 5),
        colors: [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.1).cgColor
        ]
    )
    
    
    var body: some View {
        if showMainView {
            if oauthManager.isLoggedIn {
                NavigationStack{
                    TabView(selection: $selection){
                        HomeView()
                            .commonHeader(title: "홈", onSearchAction: {
                                moveToSearchView.toggle()
                            }, onSettingsAction: {
                                moveToSettingView.toggle()
                            })
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("홈")
                            }
                            .tag(0)
                        
                        ChatView()
                            .commonHeader(title: "채팅", onSearchAction: {
                                moveToSearchView.toggle()
                            }, onSettingsAction: {
                                moveToSettingView.toggle()
                            })
                            .tabItem {
                                Image(systemName: "ellipsis.bubble")
                                Text("채팅")
                            }
                            .tag(1)
                        
                        PreemptionView()
                            .commonHeader(title: "찜", onSearchAction: {
                                moveToSearchView.toggle()
                            }, onSettingsAction: {
                                moveToSettingView.toggle()
                            })
                            .tabItem {
                                Image(systemName: "heart")
                                Text("찜")
                            }
                            .tag(2)
                        
                        ProfileView()
                            .commonHeader(title: "나의마켓", onSearchAction: {
                                moveToSearchView.toggle()
                            }, onSettingsAction: {
                                moveToSettingView.toggle()
                            })
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("나의마켓")
                            }
                            .tag(3)
                    }
                    .navigationDestination(isPresented: $moveToSettingView) {
                        SettingView()
                    }
                    .navigationDestination(isPresented: $moveToSearchView) {
                        SearchView()
                    }
                    .padding(.bottom, 8)
                    .accentColor(CommonStyle.MAIN_COLOR)
                    .onAppear{
                        let appearance = UITabBarAppearance()
                        appearance.shadowImage = image
                        
                        UITabBar.appearance().standardAppearance = appearance
                        UITabBar.appearance().backgroundColor = .white
                    }
                }
            } else {
                LoginView().environmentObject(OAuthVM())
            }
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showMainView = true
                        }
                    }
                }
        }
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

#Preview {
    ContentView()
}
