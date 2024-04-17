//
//  ArticleView.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    
    @StateObject var saleVM = SaleVM()
    @State private var isPreemption: Bool = false
    
    @State private var moveToTradeView: Bool = false
    
    let articleId: Int
    
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
                                            
                                            KFImage(URL(string: article.filePaths[index]))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .retry(maxCount: 3, interval: .seconds(5))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .containerRelativeFrame(.horizontal, count: article.filePaths.count, span: article.filePaths.count, spacing: 0)
                                                .frame(width: UIScreen.main.bounds.width, height: 320)
                                            
                                            
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
                            
                            Text(article.itemStatus == "SALE" ? "판매중": article.itemStatus == "RESERVATION" ? "예약중" : "판매완료")
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
                                
                                Text("거래 희망 장소")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(article.tradingPlace)
                                    .font(.system(size: 18))
                                
                            }
                            
                            Spacer().frame(height: 20)
                        }.padding(.horizontal, 26)
                    }
                    
                    if article.itemStatus != "COMP" {
                        VStack(spacing: 0){
                            Divider()
                                .background(CommonStyle.DIVIDER_COLOR)
                            
                            Spacer().frame(height: 16)
                            
                            HStack {
                                
                                Button(action: {
                                    isPreemption.toggle()
                                    saleVM.postPreemption(itemId: articleId)
                                }, label: {
                                    Image(systemName: isPreemption ? "heart.fill" : "heart")
                                        .font(.system(size: 24))
                                        .fontWeight(.medium)
                                        .foregroundStyle(isPreemption ? CommonStyle.HEART_COLOR : CommonStyle.GRAY_COLOR)
                                })
                                .padding(.leading, 26)
                                Spacer()
                                Button(action: {
                                    moveToTradeView.toggle()
                                }, label: {
                                    Text("예약하기")
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundStyle(CommonStyle.WHITE_COLOR)
                                        .background(CommonStyle.BTN_BLUE_COLOR)
                                        .cornerRadius(30)
                                })
                                .padding(.trailing, 26)
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Text("1:1 채팅하기")
                                        .padding(.horizontal, 36)
                                        .padding(.vertical, 12)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                        .foregroundStyle(CommonStyle.WHITE_COLOR)
                                        .background(CommonStyle.BTN_BLUE_COLOR)
                                        .cornerRadius(30)
                                })
                                .padding(.trailing, 26)
                            }
                            .padding(.bottom, 30)
                            .background(CommonStyle.WHITE_COLOR)
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .onAppear{
                    if article.preemptionItemStatus == "PREEMPTION" {
                        isPreemption = true
                    } else {
                        isPreemption = false
                    }
                }
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
        .navigationDestination(isPresented: $moveToTradeView) {
            TradeView(nickname: saleVM.article?.nickname ?? "", articleId: articleId)
        }
    }
}

#Preview {
    ArticleView(articleId: 5)
}
