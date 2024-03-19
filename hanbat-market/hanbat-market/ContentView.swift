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
    
    let image = UIImage.gradientImageWithBounds(
        bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 5),
        colors: [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.1).cgColor
        ]
    )
    
    var body: some View {
        if authManager.isLoggedIn {
            NavigationStack{
                TabView(selection: $selection){
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("홈")
                        }
                        .tag(0)
                    
                    ChatView()
                        .tabItem {
                            Image(systemName: "ellipsis.bubble")
                            Text("채팅")
                        }
                        .tag(1)
                    
                    HeartView()
                        .tabItem {
                            Image(systemName: "heart")
                            Text("찜")
                        }
                        .tag(2)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("나의마켓")
                        }
                        .tag(3)
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
            LoginView()
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
