//
//  ProfileView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

enum ProfileTab {
    case buy
    case sell
}

struct ProfileView: View {
    
    @StateObject var saleVM = SaleVM()
    
    @State private var selection: ProfileTab = .buy
    @State var moveToSaleView: Bool = false
    
    var body: some View {
        VStack{
            NavigationBar(navTitle: "나의 마켓")
            
            VStack{
                HStack {
                    Spacer()
                    Button(action: {
                        selection = .buy
                    }) {
                        Text("구매한 상품")
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        selection = .sell
                    }) {
                        Text("판매한 상품")
                    }
                    Spacer()
                }
                .font(.system(size: 16))
                .padding(.vertical, 6)
                .foregroundStyle(CommonStyle.BLACK_COLOR)
                
                Rectangle()
                    .frame(width:  UIScreen.main.bounds.width / 2, height: 2)
                    .padding(.leading, selection == .buy ? -UIScreen.main.bounds.width / 2 : 0)
                    .padding(.trailing, selection == .sell ? -UIScreen.main.bounds.width / 2 : 0)
                    .foregroundStyle(CommonStyle.MAIN_COLOR)
            }
            
            TabView(selection: $selection) {
                
                ScrollView{
                    
                    if saleVM.purchaseHistoryItems.isEmpty {
                        VStack{
                            Spacer().frame(height: 50)
                            Image(systemName: "arrow.up.bin.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                                .padding(.bottom, 10)
                            Text("구매한 상품이 아직 없어요!")
                            Text("홈에 가서 상품을 구매해보세요 :)")
                        }.fontWeight(.medium)
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                        ForEach(saleVM.purchaseHistoryItems.sorted(by: {
                            guard let date1 = DateFormatter().date(from: $0.createdAt),
                                  let date2 = DateFormatter().date(from: $1.createdAt)
                            else { return false }
                            return date1 > date2
                        }), id: \.id) { item in
                            NavigationLink {
                                ArticleView(articleId: item.id)
                            } label: {
                                VStack(alignment:.leading, spacing: 8){
                                    AsyncImage(url: URL(string: item.thumbnailFilePath), content: { Image in
                                        Image.resizable()
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(10)
                                    
                                    VStack(alignment:.leading, spacing: 2){
                                        
                                        Text(item.title)
                                            .font(.system(size: 13))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(CommonStyle.BLACK_COLOR)
                                        Text(DateUtils.relativeTimeString(from: item.createdAt))
                                            .font(.system(size: 12))
                                            .foregroundStyle(CommonStyle.GRAY_COLOR)
                                        Text("\(item.price)원")
                                            .font(.system(size: 14))
                                            .fontWeight(.bold)
                                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                                        
                                    }
                                    
                                    Spacer()
                                }.frame(width:100, height: 180)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                }
                
                .tag(ProfileTab.buy)
                .onAppear{
                    saleVM.fetchPurchaseHistory()
                }
                
                
                VStack{
                    ZStack(alignment: .bottomTrailing){
                        ScrollView{
                            
                            if saleVM.salesHistoryItems.isEmpty {
                                VStack{
                                    Spacer().frame(height: 50)
                                    Image(systemName: "shared.with.you")
                                        .font(.system(size: 38))
                                        .foregroundStyle(CommonStyle.MAIN_COLOR)
                                        .padding(.bottom, 10)
                                    Text("판매한 상품이 아직 없어요!")
                                    Text("상품을 올리고 판매해보세요 :)")
                                }.fontWeight(.medium)
                            }
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                                ForEach(saleVM.salesHistoryItems.sorted(by: {
                                    guard let date1 = DateFormatter().date(from: $0.createdAt),
                                          let date2 = DateFormatter().date(from: $1.createdAt)
                                    else { return false }
                                    return date1 > date2
                                }), id: \.id) { item in
                                    NavigationLink {
                                        if item.itemStatus == "COMP" {
                                            ArticleView(articleId: item.id)
                                        }
                                        else {
                                            SaleEditView(articleId: item.id)
                                        }
                                    } label: {
                                        VStack(alignment:.leading, spacing: 8){
                                            
                                            ZStack{
                                                
                                                AsyncImage(url: URL(string: item.thumbnailFilePath), content: { Image in
                                                    Image.resizable()
                                                }, placeholder: {
                                                    ProgressView()
                                                })
                                                .frame(width: 90, height: 90)
                                                .cornerRadius(10)
                                                
                                                if item.itemStatus == "COMP"{
                                                    
                                                    Text("판매 완료")
                                                        .font(.system(size: 14))
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.white)
                                                        .frame(width: 90, height: 90)
                                                        .background(CommonStyle.BLACK_COLOR.opacity(0.3))
                                                        .cornerRadius(10)
                                                }
                                            }
                                            
                                            
                                            VStack(alignment:.leading, spacing: 2){
                                                
                                                Text(item.title)
                                                    .font(.system(size: 13))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(CommonStyle.BLACK_COLOR)
                                                Text(DateUtils.relativeTimeString(from: item.createdAt))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                                                Text("\(item.price)원")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(CommonStyle.MAIN_COLOR)
                                                
                                            }
                                            
                                            Spacer()
                                        }.frame(width:100, height: 180)
                                    }
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                        }
                        
                        Button(action: {
                            moveToSaleView.toggle()
                        }, label: {
                            Text("판매하기")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundStyle(CommonStyle.WHITE_COLOR)
                                .background(CommonStyle.MAIN_COLOR)
                                .cornerRadius(30)
                                .shadow(radius: 2)
                        })
                        .zIndex(100)
                        .padding(.bottom, 12)
                        .padding(.trailing, 12)
                    }
                }
                .tag(ProfileTab.sell)
                .onAppear{
                    saleVM.fetchSalesHistory()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .animation(.default, value: selection)
        .navigationDestination(isPresented: $moveToSaleView) {
            SaleView()
        }
    }
}

#Preview {
    ProfileView()
}
