//
//  SearchVM.swift
//  hanbat-market
//
//  Created by dongs on 3/27/24.
//

import Foundation
import Alamofire
import Combine

class SearchVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var searchResponse: HomeResponse? = nil
    
    var fetchingSearchData = PassthroughSubject<(), Never>()
    
    func fetchSearchData(itemStatus: String? = "", title: String, itemName: String? = ""){
        print("SearchVM: fetchSearchData() called")
        SearchApiService.fetchSearchData(itemStatus: itemStatus!, title: title, itemName: itemName!)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("fetchSearchData request finished")
                case .failure(let error):
                    print("fetchSearchData errorCode: \(String(describing: error.responseCode))")
                    
                    // TODO: fetchSearchData 관련 에러 처리
                    //                    if let errorCode = error.responseCode {
                    //                        if errorCode == 401{
                    //                        }
                    //                    }
                }
            } receiveValue: { [weak self] receivedData in
                print("SearchVM fetchSearchData: \(receivedData)")
                self?.searchResponse = receivedData
                self?.fetchingSearchData.send()
            }.store(in: &subscription)
    }
}


