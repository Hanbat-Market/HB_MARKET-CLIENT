//
//  ProgressViewLarge.swift
//  hanbat-market
//
//  Created by dongs on 4/11/24.
//

import SwiftUI

struct CustomProgressView: View {
    
    var controlSize: ControlSize = .regular
    
    var body: some View {
        ProgressView()
            .controlSize(controlSize)
            .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
            .zIndex(100)
    }
}
