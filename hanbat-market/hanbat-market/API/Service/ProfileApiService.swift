//
//  ProfileApiService.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import SwiftUI
import Alamofire
import Combine

enum ProfileApiService {
    
    static func putProfileImage(imageFile: UIImage, uuid: String){
        let url = "\(ApiClient.BASE_URL)/api/profiles/image"
        
        // 파일 업로드 및 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 이미지 파일 추가
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
                    BaseInterceptor())
        .validate(statusCode: 200..<300)
        .response { response in
            // 응답 처리
            switch response.result {
            case .success:
                print("postProfileImage success")
            case .failure(let error):
                print("postProfileImage failure: \(error)")
                print("postProfileImage errorCode \(String(describing: error.responseCode))" )
                print("postProfileImage errorDes", error.localizedDescription)
            }
        }
    }
    
    static func fetchProfile(uuid: String) -> AnyPublisher<ProfileModel, AFError> {
        return ApiClient.shared.session
            .request(ProfileRouter.fetchProfile(uuid: uuid))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: ProfileResponse.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
    static func putProfileNickname(uuid: String, nickname: String) -> AnyPublisher<String, AFError> {
        return ApiClient.shared.session
            .request(ProfileRouter.putProfileNickname(uuid: uuid, nickname: nickname))
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CommonResponseModel.self)
            .value()
            .map{ receivedValue in
                receivedValue.data
            }
            .eraseToAnyPublisher()
    }
    
}

