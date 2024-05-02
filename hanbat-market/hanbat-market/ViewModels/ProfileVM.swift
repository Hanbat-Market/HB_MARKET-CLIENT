//
//  ProfileVM.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import SwiftUI
import Alamofire
import Combine

class ProfileVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var putProfileImageFailed: Bool = false
    @Published var putProfileImageIsLoading: Bool = false
    var putProfileImageSuccess = PassthroughSubject<(), Never>()
    
    func putProfileImage(imageFile: UIImage, uuid: String){
        
        let url = "\(ApiClient.BASE_URL)/api/profiles/image"
        
        AF.upload(multipartFormData: { multipartFormData in
            self.putProfileImageIsLoading = true
            
            if let imageData = imageFile.jpegData(compressionQuality: 0.5) {
                print("ProfileImageData", imageData)
                multipartFormData.append(imageData, withName: "imageFile", fileName: "profileImage.png", mimeType: "image/png")
            }
            
            
            let profileImageRequest: [String: Any] = [
                "uuid": uuid,
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: profileImageRequest, options: [])
                multipartFormData.append(jsonData, withName: "profileImageRequest", mimeType: "application/json")
            } catch {
                print("Error serializing profileImageRequest: \(error)")
            }
        }, to: url, method: .put, headers: ["Content-Type": "multipart/form-data"], interceptor:
                    UploadInterceptor())
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("postProfileImage success")
                self.putProfileImageSuccess.send()
                self.putProfileImageIsLoading = false
            case .failure(let error):
                print("postProfileImage errorCode \(String(describing: error.responseCode))" )
                print("postProfileImage errorDes", error.localizedDescription)
                self.putProfileImageFailed = true
                self.putProfileImageIsLoading = false
            }
        }
    }
    
    @Published var profileResponse: ProfileModel? = nil
     var successFetchingProfile = PassthroughSubject<(), Never>()
    
    func fetchProfile(uuid: String) {
        ProfileApiService.fetchProfile(uuid: uuid)
            .sink { completion in
                switch completion {
                case .finished:
                    print("fetchProfile request finished")
                case .failure(let error):
                    print("fetchProfile request errorCode \(String(describing: error.responseCode))" )
                    print("fetchProfile request errorDes", error.localizedDescription)
//                    if let errorCode = error.responseCode {
//                        if errorCode == 401{
//                        }
//                    }
                }
            } receiveValue: { [weak self] article in
                print("Received fetchProfile: \(article)")
                self?.profileResponse = article
                self?.successFetchingProfile.send()
            }
            .store(in: &subscription)
    }
    
    @Published var putProfileNicknameIsLoading: Bool = false
    @Published var successChangeProfileNickname: Bool = false
    
    func putProfileNickname(uuid: String, nickname: String) {
        ProfileApiService.putProfileNickname(uuid: uuid, nickname: nickname)
            .sink { completion in
                self.putProfileNicknameIsLoading = true
                switch completion {
                case .finished:
                    print("putProfileNickname request finished")
                    self.putProfileNicknameIsLoading = false
                case .failure(let error):
                    print("putProfileNickname request errorCode \(String(describing: error.responseCode))" )
                    print("putProfileNickname request errorDes", error.localizedDescription)
                    self.putProfileNicknameIsLoading = false
                }
            } receiveValue: { [weak self] article in
                print("Received putProfileNickname: \(article)")
                self?.successChangeProfileNickname = true
            }
            .store(in: &subscription)
    }
}


