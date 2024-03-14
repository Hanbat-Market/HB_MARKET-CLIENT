//
//  LoginView.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView{
            VStack(spacing: 16){
                AuthInput(placeholder: "이메일 주소", textInput: $email, keyboardType: .emailAddress)
                
                AuthInput(placeholder: "비밀번호", textInput: $password, isSecureInput: true)
                
                AuthButton(buttonAction: { print("로그인") }, buttonText: "로그인")
                
                NavigationLink(destination: RegisterView()) {
                    Text("회원가입")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
