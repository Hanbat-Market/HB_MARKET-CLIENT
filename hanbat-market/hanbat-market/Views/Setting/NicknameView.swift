//
//  NicknameView.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import SwiftUI

struct NicknameView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var profileVM = ProfileVM()
    
    @State private var changedNickname: String = ""
    
    var nickname: String = ""
    
    var body: some View {
        VStack{
            BackNavigationBar(navTitle: "닉네임 변경", customButtonAction: {
                
                profileVM.putProfileNickname(uuid: OAuthManager.shared.getUUID(), nickname: changedNickname)
                
            }, customButtonText: "완료", isDisabled: profileVM.putProfileNicknameIsLoading)
            
            ScrollView {
                TextField("변경하실 닉네임을 입력하세요.", text: $changedNickname)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(CommonStyle.SEARCH_BG_COLOR)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
            }
            .padding(.horizontal, 20)
            
        }
        .alert(isPresented: $profileVM.successChangeProfileNickname, content: {
            Alert(title: Text("닉네임이 변경되었습니다."), dismissButton: .default(Text("확인"), action: {
                self.dismiss()
            }))
        })
        .onAppear {
            if !nickname.isEmpty {
                changedNickname = nickname
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

