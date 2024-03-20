//
//  ArticleView.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI

struct ArticleView: View {
    
    @StateObject var saleVM = SaleVM()
    @State private var currentImage: Int = 0
    
    let articleId: Int
    
    var body: some View {
        VStack {
            if let article = saleVM.article {
                VStack {
                    
                    BackNavigationBar(navTitle: "\(article.nickname)님의 게시글")
                    
                    ScrollView{
                        
                        ScrollView(.horizontal){
                            LazyHStack(spacing: 0) {
                                
                                HStack(spacing: 0){
                                    
                                    ForEach(0..<article.filePaths.count, id: \.self) { index in
                                        
                                        ZStack(alignment: .bottom){
                                            AsyncImage(url: URL(string: article.filePaths[index]), content: { Image in
                                                withAnimation {
                                                    Image.resizable()
                                                }
                                                
                                            }, placeholder: {
                                                ProgressView()
                                            })
                                            .frame(width: UIScreen.main.bounds.width, height: 280)
                                            .aspectRatio(contentMode: .fill)
                                            
                                            HStack {
                                                ForEach(0..<article.filePaths.count, id: \.self) { cIndex in
                                                    withAnimation {
                                                        Circle()
                                                            .frame(width: 10, height: 10)
                                                            .foregroundColor(cIndex == index ? .white : .gray)
                                                    }
                                                    
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    Spacer().frame(height: 10)
                    
                    VStack(alignment: .leading){
                        
                        
                        HStack{
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 20))
                            
                            Text(article.nickname)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        
                        
                        Spacer().frame(height: 10)
                        
                        Divider()
                            .background(CommonStyle.DIVIDER_COLOR)
                        
                        Spacer().frame(height: 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title)
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                            Text(DateUtils.relativeTimeString(from: article.createdAt))
                        }
                        
                        Spacer().frame(height: 16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(article.description)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                            
                            Spacer().frame(height: 10)
                            
                            Text("거래 희망 장소")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Text(article.tradingPlace)
                            
                            Spacer().frame(height: 10)
                            
                            Text("판매 상태")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Text(article.articleStatus == "OPEN" ? "판매 중": "판매 완료")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                        
                    }.padding(.horizontal, 26)
                }
                .onAppear {
                    // 스크롤 뷰가 나타날 때 현재 페이지 설정
                    currentImage = 0
                }
                .padding(.bottom, 16)
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

#Preview {
    ArticleView(articleId: 5)
}
