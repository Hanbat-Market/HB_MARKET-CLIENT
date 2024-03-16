//
//  RegisterVIew.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI


struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var nickname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordCheck: String = ""
    
    @State var completeRegister: Bool = false
    
    var body: some View {
        
        
        VStack{
            
            authHeader
            
            ScrollView{
                
                VStack (alignment: .leading){
                    VStack (alignment: .leading, spacing: 4){
                        Text("회원가입")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        Text("회원이 되시면 많은 기능을 이용할 수 있어요!")
                            .font(.system(size: 15))
                            .foregroundColor(CommonStyle.GRAY_COLOR)
                    }
                    
                    Spacer().frame(height: 50)
                    
                    VStack (alignment:.leading, spacing: 16){
                        Text("닉네임*")
                        AuthInput(placeholder: "닉네임 (1~6글자)", textInput: $nickname)
                        Spacer().frame(height: 4)
                        
                        Text("이메일*")
                        AuthInput(placeholder: "이메일 주소", textInput: $email, keyboardType: .emailAddress)
                        Spacer().frame(height: 4)
                        
                        Text("비밀번호*")
                        AuthInput(placeholder: "비밀번호", textInput: $password, isSecureInput: true)
                        AuthInput(placeholder: "비밀번호 확인", textInput: $passwordCheck, isSecureInput: true)
                        
                    }
                    
                    
                    Spacer().frame(height: 50)
                    
                    
                    AuthButton(buttonAction: {
                        print("가입하기")
                        completeRegister = true
                    }, buttonText: "가입하기")
                    
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $completeRegister) {
                    CompletedView()
                }
            }
        }
    }
    
    var authHeader : some View {
        HStack{
            Spacer().frame(width: 20)
            Button{
                self.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

#Preview{
    RegisterView()
}
