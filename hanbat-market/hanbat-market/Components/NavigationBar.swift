//
//  NavigationBar.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct NavigationBar: View {
    
    var navTitle: String
    
    @State private var moveToSettingView: Bool = false
    @State private var moveToSearchView: Bool = false
    
    var body: some View {
        HStack{
            Text(navTitle)

            Spacer()
            Button(action: {
                moveToSearchView.toggle()
            }) {
                Image(systemName: "magnifyingglass")
            }
            
            Spacer().frame(width: 16)
            
            Button(action: {
                moveToSettingView.toggle()
            }, label: {
                Image(systemName: "gearshape")
            })
        }
        .font(.system(size: 20))
        .fontWeight(.bold)
        .padding(.vertical, 14)
        .padding(.horizontal, 24)
        .foregroundStyle(CommonStyle.WHITE_COLOR)
        .background(CommonStyle.MAIN_COLOR)
        .navigationDestination(isPresented: $moveToSettingView) {
            SettingView()
        }
        .navigationDestination(isPresented: $moveToSearchView) {
            SearchView()
        }
    }
}
