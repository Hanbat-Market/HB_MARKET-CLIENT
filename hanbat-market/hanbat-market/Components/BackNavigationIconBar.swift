//
//  BackNavigationIconBar.swift
//  hanbat-market
//
//  Created by dongs on 3/21/24.
//

import SwiftUI

struct BackNavigationIconBar: View {
    
    @Environment(\.dismiss) var dismiss
    
    var navTitle: String = ""
    var customButtonAction: () -> Void = {}
    var customButtonIcomImage: String = ""
    var customButtonIconColor: Color = Color.white
    
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
            Spacer()
            
            if !customButtonIcomImage.isEmpty {
                Button(action: customButtonAction) {
                    Image(systemName: customButtonIcomImage)
                        .font(.system(size: 18))
                        .foregroundStyle(customButtonIconColor)
                }
                .foregroundStyle(CommonStyle.GRAY_COLOR)
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
