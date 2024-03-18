//
//  HomeView.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            Text("홈 화면입니다")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomeView()
}
