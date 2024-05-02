//
//  SettingView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject var authVM = AuthVM()
    @State var isLogout = false
    
    var body: some View {
        VStack() {
            BackNavigationBar(navTitle: "설정")
            
            ScrollView {
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("개인 정보")
                            .fontWeight(.bold)
                        
                        NavigationLink {
                            ProfileSettingView()
                        } label: {
                            Text("프로필 보기")
                                .foregroundStyle(CommonStyle.BLACK_COLOR)
                        }
                        
                        
                        Button(action: {
                            authVM.confirmStudent(memberUuid: OAuthManager.shared.getUUID())
                        }, label: {
                            Text("재학생 인증")
                                .foregroundStyle(CommonStyle.BLACK_COLOR)
                        })
                        .alert(isPresented: $authVM.confirmStudentSuccess, content: {
                            Alert(title: Text("이미 인증이 완료된 재학생입니다."), dismissButton: .default(Text("확인")))
                        })
                        
                        Divider()
                            .background(CommonStyle.DIVIDER_COLOR)
                    }
                    
                    Spacer().frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("기타")
                            .fontWeight(.bold)
                        
                        NavigationLink {
                            PrivacyPolicy()
                        } label: {
                            Text("개인정보 처리방침")
                                .foregroundStyle(CommonStyle.BLACK_COLOR)
                        }
                        
                        NavigationLink {
                            TermOfUseView()
                        } label: {
                            Text("이용약관")
                                .foregroundStyle(CommonStyle.BLACK_COLOR)
                        }

                        
                    }
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Button(action: {
                            isLogout.toggle()
                        }, label: {
                            Text("로그아웃")
                                .alert(isPresented: $isLogout, content: {
                                    Alert(title: Text("로그아웃"), message: Text("정말 로그아웃 하시겠습니까?"), primaryButton: .cancel(Text("확인"), action: {
                                        OAuthManager.shared.oauthLogout(uuid: OAuthManager.shared.getUUID())
                                        OAuthManager.shared.isLoggedIn = false
                                    }), secondaryButton: .destructive(Text("취소"), action: {
                                        isLogout = false
                                    }))
                                })
                        })
                        Text("탈퇴하기")
                    }
                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                    
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
        .navigationDestination(isPresented: $authVM.confirmStudentFailed) {
            VerificationView()
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    SettingView()
}
