//
//  CustomTabView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

enum TabIndex {
    case home, chat, heart, profile
}

struct MyCustomTapView : View {
    
    @State var tabIndex : TabIndex = .home
    @State var largerScale : CGFloat = 1.4
    
    func changeMyView(tabIndex: TabIndex) -> any View {
        switch tabIndex {
        case .home:
            return HomeView()
        case .chat:
            return ChatView()
        case .heart:
            return HeartView()
        case .profile:
            return ProfileView()
        }
    }
    
    var body: some  View {
        
        GeometryReader{ geometry in
            ZStack(alignment:.bottom) {
                
                switch tabIndex {
                case .home: HomeView()
                case .chat: ChatView()
                case .heart: HeartView()
                case .profile:  ProfileView()
                }
                
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        Button(action: {
                            print("홈 버튼 클릭")
                            withAnimation {
                                tabIndex = .home
                            }
                            
                        }, label: {
                            Image(systemName: "house.fill")
                                .font(.system(size: 25))
                                .foregroundColor(tabIndex == .home ? CommonStyle.MAIN_COLOR : CommonStyle.GRAY_COLOR)
                                .frame(width: geometry.size.width / 3, height: 50)
                        })
                        Button(action: {
                            print("채팅 버튼 클릭")
                            withAnimation {
                                tabIndex = .chat
                            }
                            
                        }, label: {
                            Image(systemName: "ellipsis.bubble")
                                .font(.system(size: 25))
                                .foregroundColor(tabIndex == .chat ? CommonStyle.MAIN_COLOR : CommonStyle.GRAY_COLOR)
                                .frame(width: geometry.size.width / 3, height: 50)
                        })
                        Button(action: {
                            print("찜 버튼 클릭")
                            withAnimation {
                                tabIndex = .heart
                            }
                            
                        }, label: {
                            Image(systemName: "heart")
                                .font(.system(size: 25))
                                .foregroundColor(tabIndex == .heart ? CommonStyle.MAIN_COLOR : CommonStyle.GRAY_COLOR)
                                .frame(width: geometry.size.width / 3, height: 50)
                        })
                        Button(action: {
                            print("프로필 버튼 클릭")
                            withAnimation {
                                tabIndex = .profile
                            }
                            
                        }, label: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 25))
                                .foregroundColor(tabIndex == .profile ? CommonStyle.MAIN_COLOR : CommonStyle.GRAY_COLOR)
                                .frame(width: geometry.size.width / 3, height: 50)
                        })
                    }.background(.white)
                    Rectangle()
                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 20)
                        .foregroundColor(.white)
                }
                
            }
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}
