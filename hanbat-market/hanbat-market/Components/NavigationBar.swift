//
//  NavigationBar.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var title: String
    var onSearchAction: () -> Void
    var onSettingsAction: () -> Void
    
    func body(content: Content) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onSearchAction) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                
                Spacer().frame(width: 16)
                
                Button(action: onSettingsAction) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                }
            }
            .font(.system(size: 20))
            .fontWeight(.bold)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .foregroundStyle(CommonStyle.WHITE_COLOR)
            .background(CommonStyle.MAIN_COLOR)
            content
        }
    }
}

extension View {
    func commonHeader(title: String, onSearchAction: @escaping () -> Void, onSettingsAction: @escaping () -> Void) -> some View {
        self.modifier(NavigationBarModifier(title: title, onSearchAction: onSearchAction, onSettingsAction: onSettingsAction))
    }
}
