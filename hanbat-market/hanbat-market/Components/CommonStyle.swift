//
//  CommonStyle.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct CommonStyle {
    static var MAIN_COLOR = Color(hex: "6096CB")
    static var GRAY_COLOR = Color(hex: "8C8C8C")
}

// #이 있으면 제거 후 문자열로 RGB 추출
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
}
