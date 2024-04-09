//
//  SaleVM.swift
//  hanbat-market
//
//  Created by dongs on 3/20/24.
//

import SwiftUI
import Alamofire
import Combine

class SaleVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var registerFailed: Bool = false
    var registraionSuccess = PassthroughSubject<(), Never>()
    
    func register(title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage]){
        
        let url = "\(ApiClient.BASE_URL)/api/articles/new"
        
        // 파일 업로드 및 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 이미지 파일 추가
            for (index, image) in selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
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
        }, to: url, method: .post, headers: ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"], interceptor:
                    UploadInterceptor())
        .validate(statusCode: 200..<300)
        .response { response in
            // 응답 처리
            switch response.result {
            case .success:
                print("File upload success")
                self.registraionSuccess.send()
            case .failure(let error):
                print("File upload errorCode \(String(describing: error.responseCode))" )
                print("File upload errorDes", error.localizedDescription)
                self.registerFailed = true
            }
        }
    }
    
    @Published var article: ArticleModel? = nil
     var successFetchingArticle = PassthroughSubject<(), Never>()
    var authError = PassthroughSubject<(), Never>()
    
    func fetchArticle(articleId: Int) {
        SaleApiService.fetchArticle(articleId: articleId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Article request finished")
                case .failure(let error):
                    print("Article request errorCode \(String(describing: error.responseCode))" )
                    print("Article request errorDes", error.localizedDescription)
                    if let errorCode = error.responseCode {
                        if errorCode == 401{
                            self.authError.send()
                        }
                    }
                }
            } receiveValue: { [weak self] article in
                print("Received article: \(article)")
                self?.article = article
                self?.successFetchingArticle.send()
            }
            .store(in: &subscription)
    }
    
    @Published var salesHistory: SalesHistoryResponse? = nil
    
    var salesHistoryItems: [SaleHistory]? {
        guard let sales = salesHistory?.data.salesDtos,
              let reserved = salesHistory?.data.reservedDtos,
              let completed = salesHistory?.data.completedDtos else { return [] }
        
        
        return sales + reserved + completed
    }
    
    func fetchSalesHistory() {
        SaleApiService.fetchSalesHistroy()
            .sink { completion in
                switch completion {
                case .finished:
                    print("fetchSalesHistroy request finished")
                case .failure(let error):
                    print("fetchSalesHistroy request errorCode \(String(describing: error.responseCode))" )
                    print("fetchSalesHistroy request errorDes", error.localizedDescription)
                    if let errorCode = error.responseCode {
                        if errorCode == 401{
                            self.authError.send()
                        }
                    }
                }
            } receiveValue: { [weak self] salesHistory in
                print("Received fetchSalesHistroy: \(salesHistory)")
                self?.salesHistory = salesHistory
            }
            .store(in: &subscription)
    }
    
    @Published var purchaseHistory: PurchaseHistoryResponse? = nil
    
    var purchaseHistoryItems: [SaleHistory]? {
        guard let reserved = purchaseHistory?.data.reservedDtos,
              let completed = purchaseHistory?.data.completedDtos else { return [] }
        
        return reserved + completed
    }
    
    func fetchPurchaseHistory() {
        SaleApiService.fetchPurchaseHistory()
            .sink { completion in
                switch completion {
                case .finished:
                    print("fetchPurchaseHistory request finished")
                case .failure(let error):
                    print("fetchPurchaseHistory request errorCode \(String(describing: error.responseCode))" )
                    print("fetchPurchaseHistory request errorDes", error.localizedDescription)
                    if let errorCode = error.responseCode {
                        if errorCode == 401{
                            self.authError.send()
                        }
                    }
                }
            } receiveValue: { [weak self] purchaseHistory in
                print("Received fetchPurchaseHistory: \(purchaseHistory)")
                self?.purchaseHistory = purchaseHistory
            }
            .store(in: &subscription)
    }
    
    @Published var preemption: ArticlePreemptionResponse? = nil
    
    func postPreemption(itemId: Int) {
        SaleApiService.postPreemption(itemId: itemId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("postPreemption request finished")
                case .failure(let error):
                    print("postPreemption request errorCode \(String(describing: error.responseCode))" )
                    print("postPreemption request errorDes", error.localizedDescription)
                }
            } receiveValue: { [weak self] preemption in
                print("Received postPreemption: \(preemption)")
                self?.preemption = preemption
            }
            .store(in: &subscription)
    }
    
    @Published var editArticleFailed: Bool = false
    var editSuccess = PassthroughSubject<(), Never>()
    
    func editArticle(articleId: Int, title: String, price: Int, itemName: String, description: String, tradingPlace: String, selectedImages: [UIImage]){
        
        let url = "\(ApiClient.BASE_URL)/api/articles/edit/\(articleId)"
        
        AF.upload(multipartFormData: { multipartFormData in
            for (index, image) in selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
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
                multipartFormData.append(jsonData, withName: "articleUpdateRequestDto", mimeType: "application/json")
            } catch {
                print("Error serializing articleCreateRequestDto: \(error)")
            }
            
            print(multipartFormData)
        }, to: url, method: .put,  headers: ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"],interceptor:
                    UploadInterceptor())
        .validate(statusCode: 200..<300)
        .response { response in
            // 응답 처리
            switch response.result {
            case .success:
                print("File upload success")
                self.editSuccess.send()
            case .failure(let error):
                print("File upload errorCode \(String(describing: error.responseCode))" )
                print("File upload errorDes", error.localizedDescription)
                self.editArticleFailed = true
            }
        }
    }
    
     var successDeletingArticle = PassthroughSubject<(), Never>()
    
    func deleteArticle(articleId: Int) {
        SaleApiService.deleteArticle(articleId: articleId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("deleteArticle request finished")
                case .failure(let error):
                    print("deleteArticle request errorCode \(String(describing: error.responseCode))" )
                    print("deleteArticle request errorDes", error.localizedDescription)
                }
            } receiveValue: { [weak self] article in
                print("Received deleteArticle: \(article)")
                self?.successDeletingArticle.send()
            }
            .store(in: &subscription)
    }
}

