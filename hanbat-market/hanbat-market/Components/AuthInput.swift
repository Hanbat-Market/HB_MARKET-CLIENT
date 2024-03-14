//
//  AuthButton.swift
//  hanbat-market
//
//  Created by dongs on 3/14/24.
//

import SwiftUI

struct AuthInput: View {
    
    var placeholder: String
    var textInput: Binding<String>
    var isSecureInput: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        if isSecureInput {
            SecureField(placeholder, text: textInput)
                .modifier(AuthInputModifier())
        } else {
            TextField(placeholder, text: textInput)
                .modifier(AuthInputModifier())
                .keyboardType(keyboardType)
        }
            
    }
}

struct AuthInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 26)
            .padding(.vertical, 14)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(.secondary, lineWidth: 2)
            )
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
    }
}
