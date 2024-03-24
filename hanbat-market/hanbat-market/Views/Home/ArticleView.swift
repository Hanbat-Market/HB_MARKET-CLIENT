//
//  ArticleView.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI

struct ArticleView: View {
    
    @StateObject var saleVM = SaleVM()
    @State private var isPreemption: Bool = false
    
    let articleId: Int
    
    var body: some View {
        VStack {
            if let article = saleVM.article {
                VStack {
                    
                    BackNavigationIconBar(navTitle: "\(article.nickname)님의 게시글",customButtonAction: {
                        isPreemption.toggle()
                        saleVM.postPreemption(itemId: articleId)
                    }, customButtonIcomImage: isPreemption ? "heart.fill" : "heart", customButtonIconColor: CommonStyle.HEART_COLOR)
                    
                    ScrollView{
                        
                        ScrollView(.horizontal){
                            LazyHStack(spacing: 0) {
                                
                                HStack(spacing: 0){
                                    
                                    ForEach(0..<article.filePaths.count, id: \.self) { index in
                                        
                                        ZStack(alignment: .bottom){
                                            
                                            
                                            NavigationLink {
                                                ImageViewer(imageUrl: article.filePaths[index])
                                            } label: {
                                                AsyncImage(url: URL(string: article.filePaths[index]), content: { Image in
                                                    
                                                    Image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .containerRelativeFrame(.horizontal, count: article.filePaths.count, span: article.filePaths.count, spacing: 0)
                                                    
                                                }, placeholder: {
                                                    ProgressView()
                                                })
                                                .frame(height: 320)
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
                            
                            
                            HStack{
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text(article.nickname)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                            }
                            
                            
                            Spacer().frame(height: 16)
                            
                            Divider()
                                .background(CommonStyle.DIVIDER_COLOR)
                            
                            Spacer().frame(height: 16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.title)
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                                Text("\(DateUtils.relativeTimeString(from: article.createdAt)) · 관심 \(article.preemptionItemSize)")
                                    .font(.system(size: 16))
                                    .foregroundStyle(CommonStyle.GRAY_COLOR)
                            }
                            
                            Spacer().frame(height: 16)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(article.description)
                                    .font(.system(size: 20))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer().frame(height: 10)
                                
                                Text("거래 희망 장소")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                Text(article.tradingPlace)
                                    .font(.system(size: 20))
                                
                                Spacer().frame(height: 10)
                                
                                Text("판매 상태")
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                Text(article.articleStatus == "OPEN" ? "판매 중": "판매 완료")
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                            }
                            
                        }.padding(.horizontal, 26)
                    }
                }
                .padding(.bottom, 30)
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
    }
}

#Preview {
    ArticleView(articleId: 5)
}
