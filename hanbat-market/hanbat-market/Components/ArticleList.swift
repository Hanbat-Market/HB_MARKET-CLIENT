//
//  ProductList.swift
//  hanbat-market
//
//  Created by dongs on 3/21/24.
//

import SwiftUI

struct ArticleList<T>: View where T: Identifiable {
    
    var listData: [T]
    
    var body: some View {
        VStack{
            
            ScrollView{
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                    ForEach(listData, id: \.id) { item in
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
        }
    }
}
