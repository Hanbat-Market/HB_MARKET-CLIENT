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
    var customButtonAction: () -> Void = {}
    var customButtonText: String = ""
    
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
                .font(.system(size: 16))
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.trailing, !customButtonText.isEmpty ? 0: 20)
            Spacer()
            
            if !customButtonText.isEmpty {
                Button(action: customButtonAction) {
                    if !customButtonText.isEmpty{
                        Text(customButtonText)
                    }
                }
                .foregroundStyle(CommonStyle.MAIN_COLOR)
                .padding(.trailing, 20)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
}

#Preview {
    BackNavigationBar(navTitle: "판매하기", customButtonText: "완료")
}
