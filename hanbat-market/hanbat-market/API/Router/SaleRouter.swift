//
//  SaleRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import Foundation
import SwiftUI
import Alamofire

// 인증 라우터
// 회원가입, 로그인
enum SaleRouter: URLRequestConvertible {
    
    case register(title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage])
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "/api/articles/new"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .register(title, price, itemName, description, tradingPlace, selectedImages):
            var params = Parameters()
            
            // 이미지를 Base64 문자열로 변환하여 파라미터에 추가
            var imageStrings: [String] = []
            for image in selectedImages {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let base64String = imageData.base64EncodedString()
                    imageStrings.append(base64String)
                }
            }
            params["imageFiles"] = imageStrings
            
            params["articleCreateRequestDto"] = SaleModel(title: title, price: price, itemName: itemName, description: description, tradingPlace: tradingPlace)
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers.add(.contentType("multipart/form-data"))
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}

