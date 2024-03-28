//
//  ReservationView.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import SwiftUI
import CachedAsyncImage

struct ReservationView: View {
    
    @StateObject var saleVM = SaleVM()
    
    let articleId: Int
    
    let purchaser: String
    let reservedDate: String
    let reservationPlace: String
    
    
    var body: some View {
        VStack {
            if let article = saleVM.article {
                VStack(spacing:0) {
                    
                    BackNavigationIconBar(navTitle: "\(article.nickname)님의 게시글",customButtonAction: {
                        
                    }, customButtonIcomImage: "square.and.arrow.up", customButtonIconColor: CommonStyle.BLACK_COLOR)
                    
                    ScrollView{
                        ScrollView(.horizontal){
                            LazyHStack(spacing: 0) {
                                
                                HStack(spacing: 0){
                                    
                                    ForEach(0..<article.filePaths.count, id: \.self) { index in
                                        
                                        ZStack(alignment: .bottom){
                                            
                                            
                                            NavigationLink {
                                                ImageViewer(imageUrl: article.filePaths[index])
                                            } label: {
                                                CachedAsyncImage(url: URL(string: article.filePaths[index]), content: { Image in
                                                    
                                                    Image
                                                        .resizable()
                                                    //                                                            .scaledToFit()
                                                    //                                                            .scaledToFill()
                                                        .aspectRatio(contentMode: .fill)
                                                    //                                                            .containerRelativeFrame(.horizontal, count: article.filePaths.count, span: article.filePaths.count, spacing: 0)
                                                    
                                                    
                                                }, placeholder: {
                                                    ProgressView()
                                                }).frame(width: UIScreen.main.bounds.width, height: 320)
                                                
                                            }
                                            
                                            
                                            
                                            HStack {
                                                ForEach(0..<article.filePaths.count, id: \.self) { cIndex in
                                                    Circle()
                                                        .frame(width: 10, height: 10)
                                                        .foregroundColor(cIndex == index ? CommonStyle.WHITE_COLOR : CommonStyle.PLACEHOLDER_COLOR)
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        }
                                        .frame(width: UIScreen.main.bounds.width)
                                    }
                                    
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                        
                        
                        Spacer().frame(height: 20)
                        
                        VStack(alignment: .leading){
                            
                            HStack(alignment: .center){
                                Image("profile")
                                    .font(.system(size: 24))
                                
                                Text(article.nickname)
                                    .font(.system(size: 16))
                                
                                Spacer()
                                
                                Text("한밭대 재학생")
                                    .font(.system(size: 16))
                                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                            }
                            
                            
                            Spacer().frame(height: 12)
                            
                            Divider()
                                .background(CommonStyle.DIVIDER_COLOR)
                            
                            Spacer().frame(height: 12)
                            
                            Text("현재 예약중인 상품")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundStyle(CommonStyle.SALE_COLOR)
                            
                            Spacer().frame(height: 14)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.title)
                                    .font(.system(size: 26))
                                    .fontWeight(.bold)
                                Text("\(article.price)원")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text("\(DateUtils.relativeTimeString(from: article.createdAt)) · 관심 \(article.preemptionItemSize)")
                                    .font(.system(size: 16))
                                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                            }
                            
                            Spacer().frame(height: 20)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(article.description)
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer().frame(height: 16)
                                
                                Text("구매자")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(purchaser)
                                    .font(.system(size: 18))
                                
                                Spacer().frame(height: 16)
                                
                                Text("거래 예약 장소")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(reservationPlace)
                                    .font(.system(size: 18))
                                
                                Spacer().frame(height: 16)
                                
                                Text("거래 예약 일시")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(reservedDate)
                                    .font(.system(size: 18))
                                
                            }
                            
                            Spacer().frame(height: 20)
                        }.padding(.horizontal, 26)
                    }
                    
                    if article.itemStatus != "COMP" {
                        VStack(spacing: 0){
                            
                            AuthButton(buttonAction: {
                                
                            }, buttonText: "예약 취소하기")
                            .padding(.all, 20)
                            
                        }
                        .padding(.bottom, 30)
                        .background(CommonStyle.WHITE_COLOR)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            
            else {
                ProgressView()
                    .onAppear {
                        saleVM.fetchArticle(articleId: articleId)
                    }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            saleVM.subscription.removeAll()
        }
    }
}
