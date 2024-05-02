//
//  SplashView.swift
//  hanbat-market
//
//  Created by dongs on 5/2/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("landing")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashView()
}
