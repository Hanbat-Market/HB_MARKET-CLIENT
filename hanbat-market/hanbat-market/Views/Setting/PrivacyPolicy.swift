//
//  PrivacyPolicy.swift
//  hanbat-market
//
//  Created by dongs on 4/11/24.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        VStack{
            BackNavigationBar(navTitle: "개인정보 처리방침")
            
            WebView(url: URL(string: "https://donggyujin.notion.site/e58b59a6ce8d45e2934f56742be8a2de?pvs=4")!)
        }.toolbar(.hidden, for: .navigationBar)
    }
}
