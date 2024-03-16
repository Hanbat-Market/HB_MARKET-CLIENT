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
        NavigationStack{
            VStack(spacing: 16){
                Spacer()
                
                Image("hb_logo")
                    .resizable()
                    .frame(width: 157, height: 54)
                
                Spacer().frame(height: 20)
                
                AuthInput(placeholder: "이메일 주소", textInput: $email, keyboardType: .emailAddress)
                
                AuthInput(placeholder: "비밀번호", textInput: $password, isSecureInput: true)
                
                AuthButton(buttonAction: { 
                    print("로그인")
                }, buttonText: "로그인")
                
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
            .toolbar(.hidden, for: .navigationBar)
        }
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