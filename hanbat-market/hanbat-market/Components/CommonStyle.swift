//
//  CommonStyle.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct CommonStyle {
    // Common Color
    static var BLACK_COLOR = Color(hex: "000000")
    static var WHITE_COLOR = Color(hex: "FFFFFF")
    static var GRAY_COLOR = Color(hex: "8C8C8C")
    static var DIVIDER_COLOR = Color(hex: "D9D9D9")
    static var PLACEHOLDER_COLOR = Color(hex: "CCCCCC")
    static var MAIN_COLOR = Color(hex: "6096CB")
    static var MAIN_BLUE_COLOR = Color(hex: "6AA5DF")
    
    // Auth Color
    static var LOGIN_GRAY_COLOR = Color(hex: "595959")
    static var GOOGLE_BG_COLOR = Color(hex: "F1F2F5")
    
    // Assets Color
    static var HEART_COLOR = Color(hex: "FF4F59")
    static var LOGIN_BG_COLOR = Color(hex: "F0F6FC")
    
    // Article Color
    static var SALE_COLOR = Color(hex: "FB8087")
    static var BTN_BLUE_COLOR = Color(hex: "6AA5DF")
    
    // Search Color
    static var SEARCH_BG_COLOG = Color(hex: "F5F5F5")
    
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
