//
//  WebVIew.swift
//  hanbat-market
//
//  Created by dongs on 4/11/24.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    static var webView: WKWebView!
    let request: URLRequest
    
    init(url: URL) {
        self.request = URLRequest(url: url)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        if nil == Self.webView {
            Self.webView = WKWebView()
            Self.webView.scrollView.isScrollEnabled = false
        }
        if self.request.url != Self.webView.url {
            Self.webView.load(request)
        }
        return Self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
