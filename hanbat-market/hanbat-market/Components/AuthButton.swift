//
//  AuthButton.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI

struct AuthButton: View {
    
    var buttonAction: () -> Void
    var buttonText: String
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack{
                Spacer()
                Text(buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Spacer()
            }
        })
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(50)
    }
}

struct AuthButtonRectangle: View {
    
    var buttonText: String
    
    var body: some View {
        Text(buttonText)
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(50)
            
    }
}
