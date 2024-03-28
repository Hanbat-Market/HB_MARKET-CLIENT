//
//  TradeVM.swift
//  hanbat-market
//
//  Created by dongs on 3/28/24.
//

import SwiftUI
import Alamofire
import Combine

class TradeVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var tradeResponse: TradeReservationResponse? = nil
    @Published var tradeReservationFailed: Bool = false
    @Published var isLoadingtradeReservation: Bool = false
    var tradeReservationSuccess = PassthroughSubject<(), Never>()
    
    func postTradeReservation(purchaserNickname: String, articleId: Int, transactionAppointmentDateTime: String, reservationPlace: String) {
        TradeApiService.postTradeReservation(purchaserNickname: purchaserNickname, articleId: articleId, transactionAppointmentDateTime: transactionAppointmentDateTime, reservationPlace: reservationPlace)
            .sink { completion in
                self.isLoadingtradeReservation = true
                switch completion {
                case .finished:
                    print("postTradeReservation request finished")
                case .failure(let error):
                    print("postTradeReservation request errorCode \(String(describing: error.responseCode))" )
                    print("postTradeReservation request errorDes", error.localizedDescription)
                    self.tradeReservationFailed = true
                    self.isLoadingtradeReservation = false
                }
            } receiveValue: { [weak self] tradeResponse in
                print("Received postTradeReservation: \(tradeResponse)")
                self?.tradeResponse = tradeResponse
                self?.tradeReservationSuccess.send()
                self?.isLoadingtradeReservation = false
            }
            .store(in: &subscription)
    }
}


