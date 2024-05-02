//
//  ProfileModel.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import Foundation

struct ProfileResponse: Codable {
    let data: ProfileModel
}

struct ProfileModel: Codable {
    let mail: String
    let nickName: String
    let filePath: String
}

struct ProfileImageModel: Codable {
    let imageFile: String
    let profileImageRequest : ProfileImageReqeustModel
}

struct ProfileImageReqeustModel: Codable {
    let uuid: String
}

struct ProfileImageResponse: Codable {
    let data: ProfileImageResponseModel
}

struct ProfileImageResponseModel: Codable {
    let mail: String
    let imageFileName: String
}
