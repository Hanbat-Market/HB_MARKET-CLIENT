//
//  BackNavigationBar.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI

struct BackNavigationBar: View {
    
    @Environment(\.dismiss) var dismiss
    
    var navTitle: String = ""
    
    var body: some View {
        HStack(spacing: 0){
            Button{
                self.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            }.padding(.leading, 20)
            Spacer()
            Text(navTitle)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .padding(.trailing, 20)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
}
