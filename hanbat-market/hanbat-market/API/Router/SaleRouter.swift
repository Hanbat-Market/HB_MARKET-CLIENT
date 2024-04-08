//
//  SaleRouter.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import Foundation
import SwiftUI
import Alamofire

enum SaleRouter: URLRequestConvertible {
    
    case register(title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage])
    case fetchArticle(articleId: Int)
    case editArticle(articleId: Int, title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage])
    case deleteArticle(articleId: Int)
    case fetchSalesHistory
    case fetchPurchaseHistory
    case postPreemption(itemId: Int)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register: return "/api/articles/new"
        case .fetchArticle(let articleId): return "/api/articles/\(articleId)"
        case let .editArticle(articleId, _, _, _, _, _, _): return "/api/articles/edit/\(articleId)"
        case .deleteArticle(let articleId): return "/api/articles/delete/\(articleId)"
        case .fetchSalesHistory: return "/api/salesHistory"
        case .fetchPurchaseHistory: return "/api/purchaseHistory"
        case .postPreemption(let itemId): return "/api/preemption/\(itemId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register: return .post
        case .fetchArticle: return .get
        case .editArticle: return .put
        case .deleteArticle: return .delete
        case .fetchSalesHistory: return .get
        case .fetchPurchaseHistory: return .get
        case .postPreemption: return .post
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
            
        case .fetchArticle: return [:]
        case let .editArticle(_, title, price, itemName, description, tradingPlace, selectedImages):
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
            
        case .deleteArticle: return [:]
        case .fetchSalesHistory: return [:]
        case .fetchPurchaseHistory: return [:]
        case let .postPreemption(itemId):
            var params = Parameters()
            
            params["itemId"] = itemId
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        if method == .post {
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        
        return request
    }
}

