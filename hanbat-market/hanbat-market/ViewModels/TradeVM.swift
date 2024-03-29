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
    
    @Published var tradeCompleteResponse: CommonResponseModel? = nil
    @Published var tradeCompleteFailed: Bool = false
    var tradeCompleteSuccess = PassthroughSubject<(), Never>()
    
    func postTradeComplete(articleId: Int, purchaserNickname: String) {
        TradeApiService.postTradeComplete(articleId: articleId, purchaserNickname: purchaserNickname)
            .sink { completion in
                switch completion {
                case .finished:
                    print("postTradeComplete request finished")
                case .failure(let error):
                    print("postTradeComplete request errorCode \(String(describing: error.responseCode))" )
                    print("postTradeComplete request errorDes", error.localizedDescription)
                    self.tradeCompleteFailed = true
                }
            } receiveValue: { [weak self] tradeCompleteResponse in
                print("Received postTradeComplete: \(tradeCompleteResponse)")
                self?.tradeCompleteResponse = tradeCompleteResponse
                self?.tradeCompleteSuccess.send()
            }
            .store(in: &subscription)
    }
    
    @Published var tradeCancelResponse: CommonResponseModel? = nil
    @Published var tradeCancelFailed: Bool = false
    var tradeCancelSuccess = PassthroughSubject<(), Never>()
    
    func postTradeCancel(articleId: Int, purchaserNickname: String, requestMemberNickname: String) {
        TradeApiService.postTradeCancel(articleId: articleId, purchaserNickname: purchaserNickname, requestMemberNickname: requestMemberNickname)
            .sink { completion in
                switch completion {
                case .finished:
                    print("postTradeCancel request finished")
                case .failure(let error):
                    print("postTradeCancel request errorCode \(String(describing: error.responseCode))" )
                    print("postTradeCancel request errorDes", error.localizedDescription)
                    self.tradeCancelFailed = true
                }
            } receiveValue: { [weak self] tradeCancelResponse in
                print("Received postTradeCancel: \(tradeCancelResponse)")
                self?.tradeCancelResponse = tradeCancelResponse
                self?.tradeCancelSuccess.send()
            }
            .store(in: &subscription)
    }
}


