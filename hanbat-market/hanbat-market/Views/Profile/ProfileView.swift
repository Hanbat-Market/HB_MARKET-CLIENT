//
//  ProfileView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            NavigationBar(navTitle: "나의 마켓")
            
            ScrollView{
                Text("나의 마켓 화면 입니다.")
            }
        }
    }
}

