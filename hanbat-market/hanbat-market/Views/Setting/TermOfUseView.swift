//
//  TermOfUseView.swift
//  hanbat-market
//
//  Created by dongs on 4/11/24.
//

import SwiftUI

struct TermOfUseView: View {
    var body: some View {
        VStack{
            BackNavigationBar(navTitle: "이용 약관")
            
            WebView(url: URL(string: "https://donggyujin.notion.site/f4c2d06ded9542888d8d8f6f92099d59?pvs=4")!)
        }.toolbar(.hidden, for: .navigationBar)
    }
}
