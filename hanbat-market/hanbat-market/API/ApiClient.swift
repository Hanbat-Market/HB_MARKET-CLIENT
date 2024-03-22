//
//  ApiClient.swift
//  hanbat-market
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

// api 호출 클라이언트
final class ApiClient {
    static let shared = ApiClient()
    
    static let BASE_URL = "https://67da-39-119-25-167.ngrok-free.app" // 주소 변경 예정
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor() // application/json
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    var session : Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
