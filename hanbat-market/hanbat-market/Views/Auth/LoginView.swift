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
                
                VStack{
                    Spacer().frame(height: 150)
                    
                    VStack{
                        Text("한밭대학교 학생을 위한 거래 플랫폼")
                            .font(.system(size: 14))
                            .foregroundStyle(CommonStyle.LOGIN_GRAY_COLOR)
                        Image("hb_logo")
                            .resizable()
                            .frame(width: 194, height: 54)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16){
                        
                        HStack{
                            VStack{
                                Divider()
                                    .background(CommonStyle.MAIN_BLUE_COLOR)
                            }
                            Text("소셜 로그인")
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                            VStack{
                                Divider()
                                    .background(CommonStyle.MAIN_BLUE_COLOR)
                            }
                        }
                        .foregroundStyle(CommonStyle.MAIN_BLUE_COLOR)
                        
                        VStack(spacing: 2){
                            Text("간편하게 로그인하여")
                            Text("한밭마켓 서비스를 이용해보세요.")
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(CommonStyle.LOGIN_GRAY_COLOR)
                        .padding(.bottom, 18)
                    
                        
                        Button(action: {
                        }, label: {
                            HStack{
                                Spacer()
                                Image("google_logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 12)
                                Text("Google로 로그인")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                Spacer()
                            }
                        })
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .foregroundColor(CommonStyle.BLACK_COLOR)
                            .background(CommonStyle.GOOGLE_BG_COLOR)
                            .cornerRadius(50)
                        
                        Button(action: {
                        }, label: {
                            HStack{
                                Spacer()
                                Image("apple_logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 12)
                                Text("Apple로 로그인")
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                Spacer()
                            }
                        })
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .foregroundColor(CommonStyle.WHITE_COLOR)
                            .background(CommonStyle.BLACK_COLOR)
                            .cornerRadius(50)
                    }
                    
                    Spacer().frame(height: 150)
                }
                
                
                .padding(.horizontal, 20)
            }
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
    LoginView().environmentObject(AuthVM())
}
