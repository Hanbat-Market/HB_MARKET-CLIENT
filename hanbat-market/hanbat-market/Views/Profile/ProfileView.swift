//
//  ProfileView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI
import CachedAsyncImage

enum ProfileTab {
    case buy
    case sell
}

struct ProfileView: View {
    
    @StateObject var saleVM = SaleVM()
    
    @State private var selection: ProfileTab = .buy
    @State private var moveToSaleView: Bool = false
    @State private var isSessionOut: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            NavigationBar(navTitle: "나의 마켓")
            
            VStack(){
                Spacer().frame(height: 8)
                HStack {
                    Spacer()
                    Button(action: {
                        selection = .buy
                    }) {
                        Text("구매 현황")
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        selection = .sell
                    }) {
                        Text("판매 현황")
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
                    
                    if saleVM.purchaseHistory == nil {
                        VStack{
                            Spacer().frame(height: 50)
                            ProgressView()
                                .controlSize(.large)
                                .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                            Spacer().frame(height: 30)
                            Text("구매한 상품을 불러오는 중이에요!")
                        }.fontWeight(.medium)
                    } else if saleVM.purchaseHistoryItems!.isEmpty {
                        VStack{
                            Spacer().frame(height: 50)
                            Image(systemName: "arrow.up.bin.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                                .padding(.bottom, 10)
                            Text("구매한 상품이 아직 없어요!")
                            Text("홈에 가서 상품을 구매해보세요 :)")
                        }.fontWeight(.medium)
                    } else{
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                            ForEach(saleVM.purchaseHistoryItems!.sorted(by: {
                                guard let date1 = DateFormatter().date(from: $0.createdAt),
                                      let date2 = DateFormatter().date(from: $1.createdAt)
                                else { return false }
                                return date1 > date2
                            }), id: \.id) { item in
                                NavigationLink {
                                    ArticleView(articleId: item.id)
                                } label: {
                                    VStack(alignment:.leading, spacing: 8){
                                        CachedAsyncImage(url: URL(string: item.thumbnailFilePath), content: { Image in
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
                }
                
                .tag(ProfileTab.buy)
                .onAppear{
                    saleVM.fetchPurchaseHistory()
                }
                
                
                VStack{
                    ZStack(alignment: .bottom){
                        ScrollView{
                            
                            if saleVM.salesHistory == nil {
                                VStack{
                                    Spacer().frame(height: 50)
                                    ProgressView()
                                        .controlSize(.large)
                                        .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                                    Spacer().frame(height: 30)
                                    Text("판매한 상품을 불러오는 중이에요!")
                                }.fontWeight(.medium)
                            } else if  saleVM.salesHistoryItems!.isEmpty {
                                VStack{
                                    Spacer().frame(height: 50)
                                    Image(systemName: "shared.with.you")
                                        .font(.system(size: 38))
                                        .foregroundStyle(CommonStyle.MAIN_COLOR)
                                        .padding(.bottom, 10)
                                    Text("판매한 상품이 아직 없어요!")
                                    Text("상품을 올리고 판매해보세요 :)")
                                }.fontWeight(.medium)
                            } else {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                                    ForEach(saleVM.salesHistoryItems!.sorted(by: {
                                        guard let date1 = DateFormatter().date(from: $0.createdAt),
                                              let date2 = DateFormatter().date(from: $1.createdAt)
                                        else { return false }
                                        return date1 > date2
                                    }), id: \.id) { item in
                                        NavigationLink {
                                            if item.itemStatus == "COMP" {
                                                ArticleView(articleId: item.id)
                                            } else if item.itemStatus == "RESERVATION" {
                                                ReservationView(articleId: item.id, purchaser: item.purchaser!, reservedDate: item.reservedDate!, reservationPlace: item.reservationPlace!)
                                            }
                                            else {
                                                SaleEditView(articleId: item.id)
                                            }
                                        } label: {
                                            VStack(alignment:.leading, spacing: 8){
                                                
                                                ZStack{
                                                    
                                                    CachedAsyncImage(url: URL(string: item.thumbnailFilePath), content: { Image in
                                                        Image.resizable()
                                                    }, placeholder: {
                                                        ProgressView()
                                                    })
                                                    .frame(width: 90, height: 90)
                                                    .cornerRadius(10)
                                                    
                                                    if item.itemStatus == "RESERVATION"{
                                                        
                                                        Text("예약중")
                                                            .font(.system(size: 14))
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.white)
                                                            .frame(width: 90, height: 90)
                                                            .background(CommonStyle.BLACK_COLOR.opacity(0.3))
                                                            .cornerRadius(10)
                                                    }
                                                    
                                                    if item.itemStatus == "COMP"{
                                                        
                                                        Text("판매 완료")
                                                            .font(.system(size: 14))
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.white)
                                                            .frame(width: 90, height: 90)
                                                            .background(CommonStyle.BLACK_COLOR.opacity(0.7))
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
                        }
                        
                        HStack{
                            Spacer()
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
        .onReceive(saleVM.authError, perform: {
            isSessionOut = true
        })
        .alert(isPresented: $isSessionOut, content: {
            Alert(title: Text("세션이 만료되었습니다."), dismissButton: .default(Text("확인"), action: {
                SessionManager.shared.isLoggedIn = false
            }))
        })
        
    }
}

#Preview {
    ProfileView()
}
