//
//  EmptyRoomView.swift
//  hanbat-market
//
//  Created by dongs on 4/18/24.
//

import SwiftUI

struct EmptyRoomView: View {
    
    @StateObject var chatVM = ChatVM()
    @StateObject private var keyboardHandler = KeyboardUtils()
    
    @State private var moveToTradeView: Bool = false
    
    var receiverNickname: String = ""
    var roomNum: String = ""
    var receiverUuid: String = ""
    
    var body: some View {
        VStack{
            
            BackNavigationBar(navTitle: "\(String(describing: receiverNickname))")
            
            GeometryReader { geometry in
                ScrollView {
                    ForEach(chatVM.chatResponses, id: \.id) { (chatResponse: ChatResponse) in
                        VStack() {
                            if chatResponse.sender != receiverUuid {
                                HStack{
                                    VStack{
                                        Spacer()
                                        
                                        Text(DateUtils.formatChatTime(chatResponse.createdAt))
                                            .font(.system(size: 11))
                                            .foregroundStyle(CommonStyle.GRAY_COLOR)
                                            .padding(.bottom, 2)
                                    }
                                    
                                    
                                    Text(chatResponse.msg)
                                        .font(.system(size: 16))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(CommonStyle.SENDER_BG_COLOR)
                                        .cornerRadius(30)
                                    
                                }
                                .padding(.trailing, 8)
                                .frame(width: geometry.size.width, alignment: .trailing)
                                
                            } else {
                                HStack{
                                    Text(chatResponse.msg)
                                        .font(.system(size: 16))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(CommonStyle.RECEIVER_BG_COLOR)
                                        .foregroundStyle(CommonStyle.WHITE_COLOR)
                                        .cornerRadius(30)
                                    
                                    VStack{
                                        Spacer()
                                        
                                        Text(DateUtils.formatChatTime(chatResponse.createdAt))
                                            .font(.system(size: 11))
                                            .foregroundStyle(CommonStyle.GRAY_COLOR)
                                            .padding(.bottom, 2)
                                    }
                                }
                                .padding(.leading, 8)
                                .frame(width: geometry.size.width, alignment: .leading)
                                    
                            }
                        }.padding([.horizontal, .top], 2)
                    }
                }
                
            }
            .padding(.horizontal, 8)
            
            HStack {
                if receiverUuid == OAuthManager.shared.getUUID(){
                    Button(action: {
                        moveToTradeView.toggle()
                    }) {
                        Image(systemName: "clock")
                            .font(.system(size: 24))
                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                    }
                }
                
                TextField("메세지를 입력하세요", text: $chatVM.newMessage, axis: .vertical)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(CommonStyle.SEARCH_BG_COLOR)
                    .cornerRadius(30)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .lineLimit(1...3)
                
                Button(action: {
                    if !chatVM.newMessage.isEmpty{
                        chatVM.postChat(msg: chatVM.newMessage, sender: OAuthManager.shared.getUUID(), receiver: receiverUuid, roomNum: roomNum)
                        
                        if chatVM.chatResponses.isEmpty {
                            chatVM.startSSE(roomNum: roomNum)
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(CommonStyle.MAIN_COLOR)
                }
            }
            .padding()
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onDisappear{
            chatVM.stopSSE()
        }
        .onTapGesture {
            keyboardHandler.hideKeyboard()
        }
        .navigationDestination(isPresented: $moveToTradeView) {
            if let articleId = Int(roomNum.split(separator: " ").first ?? "0"){
                TradeView(nickname: receiverNickname, articleId: articleId)
            }
        }
    }
}

