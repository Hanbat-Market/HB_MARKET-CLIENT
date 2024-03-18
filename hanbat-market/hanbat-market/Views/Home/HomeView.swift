//
//  HomeView.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeVM()
    
    @State var isLogout = false
    
    var body: some View {
        
        VStack{
            
            authHeader
            
            ScrollView{
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                    ForEach(homeVM.homeResponse?.data.articles ?? [], id: \.id) { item in
                        VStack(alignment:.leading, spacing: 8){
                            AsyncImage(url: URL(string: item.fileName ?? "https://cdn.pixabay.com/photo/2023/08/05/14/24/twilight-8171206_1280.jpg"), content: { Image in
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
                
                Button(action: {
                    isLogout.toggle()
                    SessionManager.shared.logout()
                }, label: {
                    Text("로그아웃")
                })
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear{
                homeVM.loadHome()
            }
        }.navigationDestination(isPresented: $isLogout, destination: {
            LoginView()
        })
    }
    
    var authHeader : some View {
        HStack{
            Text("홈")
                

            Spacer()
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
            }
            
            Spacer().frame(width: 16)
            
            Button(action: {}, label: {
                Image(systemName: "gearshape")
            })
        }
        .font(.system(size: 20))
        .fontWeight(.bold)
        .padding(.vertical, 14)
        .padding(.horizontal, 24)
        .foregroundStyle(CommonStyle.WHITE_COLOR)
        .background(CommonStyle.MAIN_COLOR)
    }
}

#Preview {
    HomeView()
}
