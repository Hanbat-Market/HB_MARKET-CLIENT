//
//  ProfileView.swift
//  hanbat-market
//
//  Created by dongs on 4/30/24.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ProfileSettingView: View {
    
    @StateObject var profileVM = ProfileVM()
    
    @State private var moveToNicknameView: Bool = false
    
    @State private var image: String = ""
    @State private var profileImage: [UIImage] = []
    @State private var changedProfileImage: [PhotosPickerItem] = []
    
    var body: some View {
        VStack{
            BackNavigationBar(navTitle: "프로필")
            
            ScrollView {
                if profileVM.profileResponse == nil {
                    VStack{
                        Spacer().frame(height: 50)
                        ProgressView()
                            .controlSize(.large)
                            .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                        Spacer().frame(height: 30)
                        Text("프로필을 불러오는 중이에요!")
                    }.fontWeight(.medium)
                } else {
                    if let profileResponse = profileVM.profileResponse {
                        VStack(spacing: 16) {
                            
                            Spacer().frame(height: 20)
                            
                            KFImage(URL(string: image.isEmpty ? profileResponse.filePath : image))
                                .placeholder {
                                    ProgressView()
                                }
                                .retry(maxCount: 3, interval: .seconds(5))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .cornerRadius(50)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(CommonStyle.CIRCLE_BORDER_COLOR, lineWidth: 2)
                                )
                            
                            Text(profileResponse.nickName)
                                .font(.system(size: 26))
                                .fontWeight(.bold)
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                            
                            VStack{
                                Text("소셜 로그인")
                                Text(profileResponse.mail)
                            }
                            .font(.system(size: 14))
                            .foregroundStyle(CommonStyle.GRAY_COLOR)
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            moveToNicknameView.toggle()
                        }, label: {
                            Text("닉네임 변경하기")
                        })
                        .font(.system(size: 16))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(CommonStyle.MAIN_COLOR)
                        .cornerRadius(50)
                        .navigationDestination(isPresented: $moveToNicknameView) {
                            NicknameView(nickname: profileResponse.nickName)
                        }
                        
                        Spacer().frame(height: 16)
                        
                        PhotosPicker("프로필 이미지 변경하기", selection: $changedProfileImage, maxSelectionCount: 1, selectionBehavior: .ordered)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(CommonStyle.MAIN_COLOR)
                            .cornerRadius(50)
                    }
                }
            }
        }
        .onAppear {
            profileVM.fetchProfile(uuid: OAuthManager.shared.getUUID())
        }
        .onChange(of: changedProfileImage, perform: { value in
            Task {
                if let data = try await changedProfileImage.first?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        profileVM.putProfileImage(imageFile: image, uuid: OAuthManager.shared.getUUID())
                    }
                }
            }
        })
        .onReceive(profileVM.putProfileImageSuccess, perform: { _ in
            profileVM.fetchProfile(uuid: OAuthManager.shared.getUUID())
        })
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}
