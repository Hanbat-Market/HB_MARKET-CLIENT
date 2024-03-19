//
//  SettingView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct SettingView: View {
    
    @State var isLogout = false
    
    var body: some View {
        VStack() {
            BackNavigationBar(navTitle: "설정")
            
            ScrollView {
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("개인 정보")
                            .fontWeight(.bold)
                        Text("프로필 보기")
                        Text("아이디 / 비밀번호")
                        
                        Divider()
                            .background(CommonStyle.DIVIDER_COLOR)
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("기타")
                            .fontWeight(.bold)
                        Text("서비스 공지사항")
                        Text("이용약관")
                    }
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Button(action: {
                            isLogout.toggle()
                            SessionManager.shared.logout()
                        }, label: {
                            Text("로그아웃")
                        })
                        Text("탈퇴하기")
                    }
                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                    
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $isLogout, destination: {
            LoginView()
        })
    }
}

#Preview {
    SettingView()
}
