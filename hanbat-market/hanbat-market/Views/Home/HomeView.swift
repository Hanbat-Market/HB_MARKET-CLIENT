//
//  HomeView.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeVM()
    @StateObject var authManager = SessionManager.shared
    
    @State var isSessionOut: Bool = false
    
    var body: some View {
        
        VStack{
            
            NavigationBar(navTitle: "홈")
            
            ScrollView{
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                    ForEach(homeVM.homeResponse?.data.articles ?? [], id: \.id) { item in
                        VStack(alignment:.leading, spacing: 8){
                            AsyncImage(url: URL(string: item.filePaths.first ?? "https://cdn.pixabay.com/photo/2023/08/05/14/24/twilight-8171206_1280.jpg"), content: { Image in
                                Image.resizable()
                            }, placeholder: {
                                ProgressView()
                            })
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
                            }
                            
                            Spacer()
                        }.frame(width:100, height: 180)
                    }
                    
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear{
                homeVM.loadHome()
            }
            .onReceive(homeVM.responseError, perform: {
                isSessionOut = true
            })
            .alert(isPresented: $isSessionOut, content: {
                Alert(title: Text("세션이 만료되었습니다."), dismissButton: .default(Text("확인"), action: {
                    authManager.isLoggedIn = false
                }))
            })
        }
    }
}

#Preview {
    HomeView()
}
