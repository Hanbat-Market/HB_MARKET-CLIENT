//
//  LoginView.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @StateObject var authManager = SessionManager.shared
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack(spacing: 16){
                    Spacer()
                    
                    Image("hb_logo")
                        .resizable()
                        .frame(width: 162, height: 45)
                    
                    Spacer().frame(height: 20)
                    
                    AuthInput(placeholder: "이메일 주소", textInput: $email, keyboardType: .emailAddress)
                        .focused($isFocused)
                    
                    AuthInput(placeholder: "비밀번호", textInput: $password, isSecureInput: true)
                        .focused($isFocused)
                    
                    AuthButton(buttonAction: {
                        print("로그인")
                        isFocused = false
                        authVM.login(email: email, password: password)
                    }, buttonText: "로그인", backGroundColor: authManager.isLoggedIn ? CommonStyle.GRAY_COLOR : CommonStyle.MAIN_COLOR)
                    .onReceive(authVM.loginSuccess, perform: {
                        authManager.isLoggedIn = true
                    })
                    .disabled(authManager.isLoggedIn)
                    
                    NavigationLink(destination: RegisterView()) {
                        HStack{
                            Text("회원가입")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Image(systemName: "link")
                                .font(.system(size: 12))
                        }
                    }
                    
                    Spacer()
                    
                }
                
                
                .padding(.horizontal, 20)
            }
            .background(CommonStyle.LOGINBG_COLOR)
            .alert(isPresented: $authVM.loginFailed, content: {
                Alert(title: Text("로그인 실패"), message: Text("아이디 또는 비밀번호를 다시 확인해주세요."), dismissButton: .default(Text("확인")))
            })
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all)
        }
        
    }
}

extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    LoginView()
}
