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
    
    static let BASE_URL = "https://phplaravel-574671-2229990.cloudwaysapps.com"
    
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
