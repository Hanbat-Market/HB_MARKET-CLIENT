//
//  HomeVM.swift
//  hanbat-market
//
//  Created by dongs on 3/18/24.
//

import Foundation
import Alamofire
import Combine

class HomeVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var homeResponse: HomeResponse? = nil
    
    var responseSuccessHomeData = PassthroughSubject<(), Never>()
    var responseError = PassthroughSubject<(), Never>()
    
    func loadHome(){
        print("HomeVM: loadHome() called")
        HomeApiService.loadHome()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("HomeVM completion: \(completion)")
                switch completion {
                case .finished:
                    print("loadHome request finished")
                case .failure(let error):
                    print("loadHome errorCode: \(String(describing: error.responseCode))")
                    print("loadHome errorDes: \(String(describing: error.localizedDescription))")
                    if let errorCode = error.responseCode {
                        if errorCode == 401{
                            self.responseError.send()
                        }
                    }
                }
            } receiveValue: { [weak self] receivedData in
                print("HomeVM receivedUser: \(receivedData)")
                self?.homeResponse = receivedData
                self?.responseSuccessHomeData.send()
            }.store(in: &subscription)
    }
}

