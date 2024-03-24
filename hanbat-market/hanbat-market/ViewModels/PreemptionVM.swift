//
//  PreemptionVM.swift
//  hanbat-market
//
//  Created by dongs on 3/24/24.
//

import SwiftUI
import Alamofire
import Combine

class PreemptionVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var preemptionItems: PreemptionModel? = nil
     var successFetchPreemptionItems = PassthroughSubject<(), Never>()
    
    func fetchPreemptionItems() {
        PreemptionApiService.fetchPreemptionItems()
            .sink { completion in
                switch completion {
                case .finished:
                    print("fetchPreemptionItems request finished")
                case .failure(let error):
                    print("fetchPreemptionItems request errorCode \(String(describing: error.responseCode))" )
                    print("fetchPreemptionItems request errorDes", error.localizedDescription)
                }
            } receiveValue: { [weak self] preemptionItems in
                print("Received fetchPreemptionItems: \(preemptionItems)")
                self?.preemptionItems = preemptionItems
            }
            .store(in: &subscription)
    }
}
