//
//  SaleApiService.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI
import Alamofire
import Combine

// 인증 관련 api 호출
enum SaleApiService {
    
    static func register(title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage]){
        let url = "\(ApiClient.BASE_URL)/api/articles/new"
        
        // 파일 업로드 및 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 이미지 파일 추가
            for (index, image) in selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    print("[ImageData]", imageData)
                    multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).png", mimeType: "image/png")
                }
            }
            
            let articleCreateRequestDto: [String: Any] = [
                "title": title,
                "price": price,
                "itemName": itemName,
                "description": description,
                "tradingPlace": tradingPlace
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: articleCreateRequestDto, options: [])
                multipartFormData.append(jsonData, withName: "articleCreateRequestDto", mimeType: "application/json")
            } catch {
                print("Error serializing articleCreateRequestDto: \(error)")
            }
            
            print(multipartFormData)
        }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"])
        .validate(statusCode: 200..<300)
        .response { response in
            // 응답 처리
            switch response.result {
            case .success:
                print("File upload success")
            case .failure(let error):
                print("File upload failure: \(error)")
                print("errorCode \(String(describing: error.responseCode))" )
                print("errorCode", error.localizedDescription)
            }
        }
    }
    
    static func fetchArticle(articleId: Int) -> AnyPublisher<ArticleModel, AFError> {
        return ApiClient.shared.session
            .request(SaleRouter.fetchArticle(articleId: articleId))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ArticleResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchSalesHistroy() -> AnyPublisher<SalesHistoryResponse, AFError> {
        return ApiClient.shared.session
            .request(SaleRouter.fetchSalesHistory)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: SalesHistoryResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func fetchPurchaseHistory() -> AnyPublisher<PurchaseHistoryResponse, AFError> {
        return ApiClient.shared.session
            .request(SaleRouter.fetchPurchaseHistory)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: PurchaseHistoryResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func postPreemption(itemId: Int) -> AnyPublisher<ArticlePreemptionResponse, AFError> {
        return ApiClient.shared.session
            .request(SaleRouter.postPreemption(itemId: itemId))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ArticlePreemptionResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue
            }
            .eraseToAnyPublisher()
    }
    
    static func editArticle(articleId:Int, title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage]){
        let url = "\(ApiClient.BASE_URL)/api/articles/edit/\(articleId)"
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (index, image) in selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    print("[ImageData]", imageData)
                    multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).png", mimeType: "image/png")
                }
            }
            
            let articleCreateRequestDto: [String: Any] = [
                "title": title,
                "price": price,
                "itemName": itemName,
                "description": description,
                "tradingPlace": tradingPlace
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: articleCreateRequestDto, options: [])
                multipartFormData.append(jsonData, withName: "articleCreateRequestDto", mimeType: "application/json")
            } catch {
                print("Error serializing articleCreateRequestDto: \(error)")
            }
            
            print(multipartFormData)
        }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"])
        .validate(statusCode: 200..<300)
        .response { response in
            // 응답 처리
            switch response.result {
            case .success:
                print("File upload success")
            case .failure(let error):
                print("File upload failure: \(error)")
                print("errorCode \(String(describing: error.responseCode))" )
                print("errorCode", error.localizedDescription)
            }
        }
    }
    
    static func deleteArticle(articleId: Int) -> AnyPublisher<String, AFError> {
        return ApiClient.shared.session
            .request(SaleRouter.deleteArticle(articleId: articleId))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonArticleModel.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
}
