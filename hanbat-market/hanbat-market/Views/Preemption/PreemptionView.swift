//
//  HeartView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI
import Kingfisher

struct PreemptionView: View {
    @StateObject var preemptionVM = PreemptionVM()
    
    @State private var isSessionOut: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0){
            
            ScrollView{
                
                if preemptionVM.preemptionItems?.preemptionItemDtos == nil {
                    VStack{
                        Spacer().frame(height: 50)
                        ProgressView()
                            .controlSize(.large)
                            .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                        Spacer().frame(height: 30)
                        Text("찜한 상품을 불러오는 중이에요!")
                    }.fontWeight(.medium)
                }else if preemptionVM.preemptionItems!.preemptionItemDtos.isEmpty {
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
                                KFImage(URL(string: item.thumbnailFilePath))
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .retry(maxCount: 3, interval: .seconds(5))
                                    .resizable()
                                    .scaledToFill()
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
        .onReceive(preemptionVM.authError, perform: {
            isSessionOut = true
        })
        .alert(isPresented: $isSessionOut, content: {
            Alert(title: Text("세션이 만료되었습니다."), dismissButton: .default(Text("확인"), action: {
                SessionManager.shared.isLoggedIn = false
            }))
        })
    }
}

