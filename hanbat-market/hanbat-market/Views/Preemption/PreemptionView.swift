//
//  HeartView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct PreemptionView: View {
    @StateObject var preemptionVM = PreemptionVM()
    
    var body: some View {
        
        VStack{
            
            NavigationBar(navTitle: "찜")
            
            
            ScrollView{
                
                if ((preemptionVM.preemptionItems?.preemptionItemDtos.isEmpty) == nil) {
                    VStack{
                        Spacer().frame(height: 50)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                            .padding(.bottom, 10)
                        Text("찜에 등록한 상품이 아직 없어요!")
                        Text("상품을 찜하고 간편하게 구매해보세요 :)")
                    }.fontWeight(.medium)
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 4) {
                    ForEach(preemptionVM.preemptionItems?.preemptionItemDtos ?? [], id: \.id) { item in
                        NavigationLink {
                            ArticleView(articleId: item.id)
                        } label: {
                            VStack(alignment:.leading, spacing: 8){
                                AsyncImage(url: URL(string: item.thumbnailFilePath), content: { Image in
                                    Image.resizable()
                                        .scaledToFill()
                                }, placeholder: {
                                    ProgressView()
                                })
                                .frame(width: 90, height: 90)
                                .cornerRadius(10)
                                
                                VStack(alignment:.leading, spacing: 2){
                                    
                                    Text(item.seller)
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
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear{
            preemptionVM.fetchPreemptionItems()
        }
    }
}

