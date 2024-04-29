//
//  VerificationView.swift
//  hanbat-market
//
//  Created by dongs on 4/29/24.
//

import SwiftUI

struct VerificationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var authVM = AuthVM()
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var notValidEmail: Bool = false
    
    @State private var verifyStudentSuccess: Bool = false
    @State private var matchStudentFailed: Bool = false
    @State private var matchStudentSuccess: Bool = false
    
    var body: some View {
        VStack {
            BackNavigationBar(navTitle: "재학생 인증")
            
            ScrollView{
                
                Spacer().frame(height: 50)
                
                VStack{
                    Text("한밭대학교 재학생 인증을 통해")
                        .font(.system(size: 14))
                        .foregroundStyle(CommonStyle.LOGIN_GRAY_COLOR)
                    Text("한밭마켓 기능을 모두 이용해보세요!")
                        .font(.system(size: 14))
                        .foregroundStyle(CommonStyle.LOGIN_GRAY_COLOR)
                    Image("hb_logo")
                        .resizable()
                        .frame(width: 194, height: 54)
                }
                
                Spacer().frame(height: 50)
                
                VStack(spacing: 18) {
                    TextField("학교 이메일을 입력하세요.", text: $email)
                        .font(.system(size: 16))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(verifyStudentSuccess ? CommonStyle.GRAY_COLOR : CommonStyle.SEARCH_BG_COLOR)
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        .disabled(verifyStudentSuccess)
                    
                    if verifyStudentSuccess {
                        TextField("이메일로 전송된 인증 번호를 입력하세요.", text: $number)
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(CommonStyle.SEARCH_BG_COLOR)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .keyboardType(.numberPad)
                        
                    }
                }
                
                Spacer().frame(height: 50)
                
                VStack{
                    Text("* 이메일 인증 방법")
                    
                    Text("1. https://gsuite.hanbat.ac.kr 에 접속")
                    Text("2. 대학 학사관리시스템 계정 및 암호로 로그인")
                    Text("3. 메일에서 인증번호 확인 및 인증하기")
                    Text("(이메일 : 학번@edu.hanbat.ac.kr)")
                }
                .font(.system(size: 14))
                .foregroundStyle(CommonStyle.LOGIN_GRAY_COLOR)
                
            }
            .padding(.horizontal, 30)
            .alert(isPresented: $authVM.matchStudentSuccess, content: {
                Alert(title: Text("재학생 인증되었습니다."), dismissButton: .default(Text("확인"), action: {
                    self.dismiss()
                }))
            })
            
            if verifyStudentSuccess {
                
                AuthButton(buttonAction: {
                    authVM.matchStudent(memberUuid: OAuthManager.shared.getUUID(), number: number)
                    
                }, buttonText: "인증하기", backGroundColor: number.isEmpty ? CommonStyle.GRAY_COLOR : CommonStyle.MAIN_COLOR)
                .disabled(number.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                .alert(isPresented: $authVM.matchStudentFailed, content: {
                    Alert(title: Text("인증 번호가 올바르지 않거나, 잘못된 접근입니다."), dismissButton: .default(Text("확인")))
                })
            } else {
                AuthButton(buttonAction: {
                    if RegexUtils.isValidStudentEmail(email) {
                        authVM.verifyStudent(mail: email, memberUuid: OAuthManager.shared.getUUID())
                    } else {
                        notValidEmail = true
                    }
                }, buttonText:  "인증번호 전송", backGroundColor: email.isEmpty ? CommonStyle.GRAY_COLOR : CommonStyle.MAIN_COLOR)
                .disabled(email.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                .alert(isPresented: $notValidEmail, content: {
                    Alert(title: Text("이메일 형식이 올바르지 않습니다."), dismissButton: .default(Text("확인")))
                })
            }
        }
        .onReceive(authVM.verifyStudentSuccess, perform: {
            verifyStudentSuccess = true
        })
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    VerificationView()
}
