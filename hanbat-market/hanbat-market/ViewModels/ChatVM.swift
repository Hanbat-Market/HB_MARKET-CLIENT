//
//  ChatVM.swift
//  hanbat-market
//
//  Created by dongs on 4/14/24.
//

import Foundation
import Alamofire
import Combine
import LDSwiftEventSource

class ChatVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var chatResponses: [ChatResponse] = [] // 채팅 메시지 목록을 보관
    @Published var lastError: Error?
    @Published var newMessage: String = ""
    
    private var eventSource: EventSource?
    private var cancellables = Set<AnyCancellable>()
    
    // SSE 스트림을 시작하는 메서드
    func startSSE(roomNum: String) {
        let url = "\(ApiClient.BASE_URL)/chat/roomNum/\(roomNum)"
        
        // SSE 이벤트 처리기를 사용한 구성 생성
        if let sseUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
        
            var config = EventSource.Config(handler: SseEventHandler(chatVM: self), url: URL(string: sseUrl)!)
            print("sseUrl",sseUrl)
            
            // 권한 토큰이 있는 경우 헤더 추가
            if let accessToken = UserDefaults.standard.string(forKey: "Authorization") {
                config.headers = ["Authorization": "Bearer \(accessToken)"]
            }
            
            // 연결 유지 시간 설정
            config.idleTimeout = 500.0
            
            // EventSource 인스턴스 생성
            eventSource = EventSource(config: config)
            
            // SSE 스트림 시작
            eventSource?.start()
        }
    }
    
    // SSE 스트림을 종료하는 메서드
    func stopSSE() {
        eventSource?.stop()
        eventSource = nil
    }
    
    // 채팅 응답을 처리하는 메서드
    func handleChatResponse(_ chatResponse: ChatResponse) {
        // 채팅 메시지를 chatResponses 배열에 추가
        DispatchQueue.main.async {
            self.chatResponses.append(chatResponse)
        }
    }
    
    func initializeChatData() {
        DispatchQueue.main.async {
            self.chatResponses.removeAll()
        }
    }
    
    @Published var chatResponse: ChatResponse? = nil
    
    func postChat(msg: String, sender: String, receiver: String, roomNum: String){
        print("ChatVM: postChat() called")
        DispatchQueue.global(qos: .background).async{
            ChatApiService.postChat(msg: msg, sender: sender, receiver: receiver, roomNum: roomNum)
                .sink { (completion: Subscribers.Completion<AFError>) in
                    switch completion {
                    case .finished:
                        print("postChat request finished")
                    case .failure(let error):
                        print("postChat errorCode: \(String(describing: error.responseCode))")
                        
                        // TODO: postChat 관련 에러 처리
                        //                    if let errorCode = error.responseCode {
                        //                        if errorCode == 401{
                        //                        }
                        //                    }
                    }
                } receiveValue: { [weak self] receivedData in
                    print("ChatVM fetchSearchData: \(receivedData)")
                    self?.chatResponse = receivedData
                    // 새로운 메시지를 전송 후 입력 필드를 비워줌
                    self?.newMessage = ""
                }.store(in: &self.subscription)
        }
    }
    
    @Published var chatRoomsResponse: [ChatRoomsResponse]? = nil
    
    func fetchChatRooms(){
        print("ChatVM: fetchChatRooms() called")
        
        let senderId = OAuthManager.shared.getUUID()
        
        ChatApiService.fetchChatRooms(senderId: senderId)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("fetchChatRooms request finished")
                case .failure(let error):
                    print("fetchChatRooms errorCode: \(String(describing: error.responseCode))")
                    
                    // TODO: fetchChatRooms 관련 에러 처리
                    //                    if let errorCode = error.responseCode {
                    //                        if errorCode == 401{
                    //                        }
                    //                    }
                }
            } receiveValue: { [weak self] receivedData in
                print("ChatVM fetchChatRooms: \(receivedData)")
                self?.chatRoomsResponse = receivedData
            }.store(in: &subscription)
    }
}
class SseEventHandler: EventHandler {
    // ChatVM을 참조하여 이벤트 처리 결과를 저장 및 처리
    private weak var chatVM: ChatVM?
    
    init(chatVM: ChatVM) {
        self.chatVM = chatVM
    }
    
    func onOpened() {
        print("SSE connection opened.")
        
        chatVM?.initializeChatData()
    }
    
    func onClosed() {
        print("SSE connection closed.")
    }
    
    func onMessage(eventType: String, messageEvent: MessageEvent) {
        let dataString = messageEvent.data
        print("Received data: \(dataString)")
        
        let decoder = JSONDecoder()
        if let data = dataString.data(using: .utf8),
           let chatResponse = try? decoder.decode(ChatResponse.self, from: data) {
            
            chatVM?.handleChatResponse(chatResponse)
        } else {
            print("Failed to decode chat response.")
        }
    }
    
    func onComment(comment: String) {
        print("Received comment: \(comment)")
    }
    
    func onError(error: Error) {
        print("SSE error occurred: \(error)")
        chatVM?.lastError = error
    }
}
