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
                self.registraionSuccess.send()
            case .failure(let error):
                print("File upload errorCode \(String(describing: error.responseCode))" )
                print("File upload errorDes", error.localizedDescription)
                self.registerFailed = true
            }
        }
    }
    
    @Published var article: ArticleModel? = nil
    
    func fetchArticle(articleId: Int) {
        SaleApiService.fetchArticle(articleId: articleId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Article request finished")
                case .failure(let error):
                    print("Article request errorCode \(String(describing: error.responseCode))" )
                    print("Article request errorDes", error.localizedDescription)
                }
            } receiveValue: { [weak self] article in
                print("Received article: \(article)")
                self?.article = article
            }
            .store(in: &subscription)
    }
    
    @Published var salesHistory: SalesHistoryResponse? = nil
    
    var salesHistoryItems: [SaleHistory] {
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
                }
            } receiveValue: { [weak self] salesHistory in
                print("Received fetchSalesHistroy: \(salesHistory)")
                self?.salesHistory = salesHistory
            }
            .store(in: &subscription)
    }
    
    @Published var purchaseHistory: PurchaseHistoryResponse? = nil
    
    var purchaseHistoryItems: [SaleHistory] {
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
                }
            } receiveValue: { [weak self] purchaseHistory in
                print("Received fetchPurchaseHistory: \(purchaseHistory)")
                self?.purchaseHistory = purchaseHistory
            }
            .store(in: &subscription)
    }
}

