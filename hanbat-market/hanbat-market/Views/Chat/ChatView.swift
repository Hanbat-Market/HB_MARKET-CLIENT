//
//  ChatView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var chatVM = ChatVM()
    
    var body: some View {
        VStack(spacing: 0){
            
            ScrollView{
                
                if chatVM.chatRoomsResponse == nil {
                    VStack{
                        Spacer().frame(height: 50)
                        ProgressView()
                            .controlSize(.large)
                            .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                        Spacer().frame(height: 30)
                        Text("채팅방 목록을 불러오는 중이에요!")
                    }.fontWeight(.medium)
                } else if chatVM.chatRoomsResponse!.isEmpty {
                    VStack{
                        Spacer().frame(height: 50)
                        Image(systemName: "ellipsis.bubble.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                            .padding(.bottom, 10)
                        Text("채팅 중인 방이 아직 없어요!")
                        Text("상대방과 채팅하고 물건을 거래해보세요 :)")
                    }.fontWeight(.medium)
                }   else {
                    if let chatRoomsResponse = chatVM.chatRoomsResponse{
                        ForEach(chatRoomsResponse, id: \.roomNum) { room in
                            NavigationLink {
                                RoomView(receiverNickname: OAuthManager.shared.getUUID() == room.senderUuid ? room.receiverNickname : room.senderNickname, roomNum: room.roomNum, receiverUuid: OAuthManager.shared.getUUID() == room.senderUuid ? room.receiverUuid : room.senderUuid)
                            } label: {
                                VStack(alignment:.leading, spacing: 12) {
                                    HStack {
                                        Text(OAuthManager.shared.getUUID() == room.senderUuid ? room.receiverNickname : room.senderNickname)
                                        Spacer()
                                        Text(DateUtils.relativeTimeString(from: room.createdAt))
                                    }
                                    Text(room.lastChat)
                                    
                                    Divider()
                                }
                                .foregroundStyle(CommonStyle.BLACK_COLOR)
                            }
                        }
                    }
                    
                }
                
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            chatVM.fetchChatRooms()
        }
    }
}

#Preview {
    ChatView()
}
