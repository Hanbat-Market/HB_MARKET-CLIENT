//
//  ChatView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack{
            NavigationBar(navTitle: "채팅")
            
            ScrollView{
                Text("채팅 화면 입니다.")
            }
        }
    }
}
