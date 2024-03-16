//
//  CompletedView.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI

struct CompletedView: View {
    
    var body: some View {
        VStack(spacing: 10){
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.system(size: 80))
                .foregroundColor(CommonStyle.MAIN_COLOR)
            
            Spacer().frame(height: 16)
            
            Text("회원가입 완료")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text("가입한 정보로 로그인 해주세요.")
                .font(.system(size: 16))
                .foregroundColor(CommonStyle.GRAY_COLOR)
            
            Spacer()
            
            NavigationLink(destination: LoginView()) {
                AuthButtonRectangle(buttonText: "로그인")
            }
            
            Spacer().frame(height: 50)
        }
        .padding(.horizontal, 20)
        .toolbar(.hidden, for: .navigationBar)
    }
}
#Preview {
    CompletedView()
}
