//
//  HomeView.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @StateObject var homeVM = HomeVM()
    @StateObject var authVM = AuthVM()
    @StateObject var oauthManager = OAuthManager.shared
    
    @State var isSessionOut: Bool = false
    @State var moveToSaleView: Bool = false
    @State var alert: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack(alignment:.bottomTrailing){
                
                ScrollView{
                    
                    if homeVM.homeResponse?.data.articles == nil {
                        VStack{
                            Spacer().frame(height: 50)
                            ProgressView()
                                .controlSize(.large)
                                .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                            Spacer().frame(height: 30)
                            Text("홈 상품을 불러오는 중이에요!")
                        }.fontWeight(.medium)
                    } else if homeVM.homeResponse!.data.articles.isEmpty{
                        VStack{
                            Spacer().frame(height: 50)
                            Image(systemName: "house.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                                .padding(.bottom, 10)
                            Text("메인에 올라온 상품이 아직 없어요!")
                            Text("제일 먼저 상품을 판매해보세요 :)")
                        }.fontWeight(.medium)
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                        ForEach(homeVM.homeResponse?.data.articles ?? [], id: \.id) { item in
                            NavigationLink {
                                ArticleView(articleId: item.id)
                            } label: {
                                VStack(alignment:.leading, spacing: 8){
                                    KFImage(URL(string: item.thumbnailFilePath))
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .retry(maxCount: 3, interval: .seconds(5))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(10)
                                    
                                    VStack(alignment:.leading, spacing: 2){
                                        
                                        Text(item.memberNickname)
                                            .font(.system(size: 12))
                                            .foregroundStyle(CommonStyle.GRAY_COLOR)
                                        Text("\(item.price)원")
                                            .font(.system(size: 14))
                                            .fontWeight(.bold)
                                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                                        Text(item.title)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                }.frame(width:100, height: 180)
                            }
                            
                            
                        }
                        
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                }
                .alert(isPresented: $isSessionOut, content: {
                    Alert(title: Text("세션이 만료되었습니다."), dismissButton: .default(Text("확인"), action: {
                        oauthManager.isLoggedIn = false
                        oauthManager.oauthLogout(uuid: OAuthManager.shared.getUUID())
                    }))
                })
                
                Button(action: {
                    authVM.confirmStudent(memberUuid: OAuthManager.shared.getUUID())
                    
                }, label: {
                    if authVM.confirmStudentSuccess {
                            NavigationLink {
                                SaleView()
                            } label: {
                                Text("판매하기")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                    .foregroundStyle(CommonStyle.WHITE_COLOR)
                                    .background(CommonStyle.MAIN_COLOR)
                                    .cornerRadius(30)
                                    .shadow(radius: 2)
                            }
                    } else {
                        Text("판매하기")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundStyle(CommonStyle.WHITE_COLOR)
                            .background(CommonStyle.MAIN_COLOR)
                            .cornerRadius(30)
                            .shadow(radius: 2)
                            .alert(isPresented: $authVM.confirmStudentFailed, content: {
                                Alert(title: Text("설정 > 재학생 인증이 필요합니다."), dismissButton: .default(Text("확인")))
                            })
                    }
                    
                })
                .padding(.bottom, 12)
                .padding(.trailing, 12)
                
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear{
            homeVM.loadHome()
        }
        .onReceive(homeVM.responseError, perform: {
            isSessionOut = true
        })
    }
}

#Preview {
    HomeView()
}
