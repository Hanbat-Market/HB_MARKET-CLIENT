//
//  NavigationBar.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct NavigationBar: View {
    
    var navTitle: String
    
    @State var moveToSettingView: Bool = false
    
    var body: some View {
        HStack{
            Text(navTitle)

            Spacer()
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
            }
            
            Spacer().frame(width: 16)
            
            Button(action: {
                print("설정화면으로")
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
    }
}
