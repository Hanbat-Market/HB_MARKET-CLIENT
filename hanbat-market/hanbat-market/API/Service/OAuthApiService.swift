//
//  OAuthApiService.swift
//  hanbat-market
//
//  Created by dongs on 4/7/24.
//

import SwiftUI
import WebKit

struct OAuthApiService: UIViewControllerRepresentable {
    let url: URL
    let onRedirect: ((String) -> Void)?
    
    func makeUIViewController(context: Context) -> OAuthApiServiceController {
        let controller = OAuthApiServiceController()
        controller.url = url
        controller.onRedirect = onRedirect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: OAuthApiServiceController, context: Context) {
        // TODO: update UI View
    }
}

class OAuthApiServiceController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL!
    var onRedirect: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Mobile Safari/537.36"
        
        view = webView
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let authorizationCookies = cookies.filter { $0.name == "Authorization" }
            
            // Authorization 쿠키가 존재할 때 처리
            if let authorizationCookie = authorizationCookies.first {
                let accessToken = authorizationCookie.value
                
                // 가져온 액세스 토큰 처리
//                print("Access Token: \(accessToken)")
                self.onRedirect?(accessToken)
            }
        }
        
        
        decisionHandler(.allow)
    }
}

