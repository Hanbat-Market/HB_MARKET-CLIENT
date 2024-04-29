//
//  RoomView.swift
//  hanbat-market
//
//  Created by dongs on 4/15/24.
//

import SwiftUI

struct RoomView: View {
    
    @StateObject var chatVM = ChatVM()
    @StateObject private var keyboardHandler = KeyboardUtils()
    
    @State private var moveToTradeView: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    var receiverNickname: String = ""
    var roomNum: String = ""
    var receiverUuid: String = ""
    var senderUuid: String = ""
    
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack{
            ScrollViewReader{ scrollView in
                
                BackNavigationBar(navTitle: "\(String(describing: receiverNickname))")
                
                ZStack{
                    GeometryReader { geometry in
                        ScrollView {
                            ForEach(chatVM.chatResponses, id: \.id) { (chatResponse: ChatResponse) in
                                VStack() {
                                    if OAuthManager.shared.getUUID() == chatResponse.sender {
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
                                }
                                .padding([.horizontal, .top], 2)
                                .id(chatResponse.createdAt)
                            }
                            
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                if let lastCreatedAt = chatVM.chatResponses.last?.createdAt {
                                    scrollView.scrollTo(lastCreatedAt, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                }
                
                .padding(.horizontal, 8)
                
                if #available(iOS 17.0, *) {
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
                        
                        TextField("메세지를 입력하세요", text: $newMessage, axis: .vertical)
                            .focused($isTextFieldFocused)
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(CommonStyle.SEARCH_BG_COLOR)
                            .cornerRadius(30)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .lineLimit(1...3)
                        
                        Button(action: {
                            if !newMessage.isEmpty{
                                chatVM.postChat(msg: newMessage, sender: OAuthManager.shared.getUUID(), receiver: OAuthManager.shared.getUUID() == senderUuid ? receiverUuid : senderUuid, roomNum: roomNum)
                                
                                newMessage = ""
                            }
                            DispatchQueue.main.async {
                                isTextFieldFocused = true
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                        }
                    }
                    .padding()
                    .onChange(of: chatVM.chatResponses.count, {
                        scrollView.scrollTo(chatVM.chatResponses.last?.createdAt, anchor: .bottom)
                    })
                } else {
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
                        
                        TextField("메세지를 입력하세요", text: $newMessage, axis: .vertical)
                            .focused($isTextFieldFocused)
                            .font(.system(size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(CommonStyle.SEARCH_BG_COLOR)
                            .cornerRadius(30)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .lineLimit(1...3)
                        
                        Button(action: {
                            if !newMessage.isEmpty{
                                chatVM.postChat(msg: newMessage, sender: OAuthManager.shared.getUUID(), receiver: OAuthManager.shared.getUUID() == senderUuid ? receiverUuid : senderUuid, roomNum: roomNum)
                                
                                newMessage = ""
                            }
                            DispatchQueue.main.async {
                                isTextFieldFocused = true
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                        }
                    }
                    .padding()
                    .task {
                        await MainActor.run {
                            scrollView.scrollTo(chatVM.chatResponses.last?.createdAt, anchor: .bottom)
                        }
                    }
                }
            }
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            chatVM.startSSE(roomNum: roomNum)
        }
        .onDisappear{
            chatVM.stopSSE()
        }
        .onTapGesture {
            keyboardHandler.hideKeyboard()
            isTextFieldFocused = false
            
        }
        .navigationDestination(isPresented: $moveToTradeView) {
            if let articleId = Int(roomNum.split(separator: " ").first ?? "0"){
                TradeView(nickname: receiverNickname, articleId: articleId)
            }
        }
    }
}
