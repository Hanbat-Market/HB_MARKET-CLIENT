//
//  SettingView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var authVM: AuthVM
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
        .alert(isPresented: $isLogout, content: {
            Alert(title: Text("로그아웃"), message: Text("정말 로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("취소"), action: {
                isLogout = false
            }), secondaryButton: .cancel(Text("확인"), action: {
                authVM.logout()
                SessionManager.shared.isLoggedIn = false
            }))
        })
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    SettingView()
}
