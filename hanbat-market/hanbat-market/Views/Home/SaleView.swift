//
//  SaleView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI
import PhotosUI
import Combine

let INIT_DESCRIPTION = "상품에 대한 설명을 작성해주세요.\n설명을 자세히 적을수록 구매자가 신뢰할 수 있는 게시글이 완성돼요."

struct SaleView: View {
    
    @StateObject private var keyboardHandler = KeyboardUtils()
    
    @StateObject var saleVM = SaleVM()
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var itemName: String = ""
    @State private var price: String = ""
    @State private var description: String = INIT_DESCRIPTION
    @State private var tradingPlace: String = ""
    
    @State private var images: [UIImage] = []
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var isSuccessUpload: Bool = false
    @State private var isLoading: Bool = false
    @State private var isSessionOut: Bool = false
    
    var body: some View {
        VStack {
            
            BackNavigationBar(navTitle: "상품 판매하기", customButtonAction: {
                print("완료")
                isLoading = true
                
                saleVM.register(title: title, price: Int(price) ?? 0, itemName: itemName, description: description, tradingPlace: tradingPlace, selectedImages: images)
                isSuccessUpload = true
            }, customButtonText: "완료", isDisabled: saleVM.registerIsLoading)
            
            ZStack{
                if saleVM.registerIsLoading {
                    CustomProgressView(controlSize: .large)
                }
                ScrollView {
                    
                    VStack(alignment:.leading, spacing: 16){
                        Text("제목")
                            .padding(.leading, 6)
                            .fontWeight(.medium)
                        AuthInput(placeholder: "제목을 입력해주세요.", textInput: $title, keyboardType: .default)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment:.leading, spacing: 16){
                        Text("상품명")
                            .padding(.leading, 6)
                            .fontWeight(.medium)
                        AuthInput(placeholder: "상품명을 입력해주세요.", textInput: $itemName, keyboardType: .default)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment:.leading, spacing: 16){
                        Text("가격 (원)")
                            .padding(.leading, 6)
                            .fontWeight(.medium)
                        AuthInput(placeholder: "가격을 입력해주세요.", textInput: $price, keyboardType: .numberPad)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment:.leading, spacing: 16){
                        Text("희망 거래 장소")
                            .padding(.leading, 6)
                            .fontWeight(.medium)
                        AuthInput(placeholder: "장소를 입력해주세요.", textInput: $tradingPlace, keyboardType: .default)
                        
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment:.leading, spacing: 16){
                        Text("상품 설명")
                            .padding(.leading, 6)
                            .fontWeight(.medium)
                        TextEditor(text: $description)
                            .padding(.horizontal, 26)
                            .padding(.vertical, 14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(CommonStyle.MAIN_COLOR, lineWidth: 2)
                            )
                            .foregroundStyle(self.description == INIT_DESCRIPTION ? CommonStyle.PLACEHOLDER_COLOR : CommonStyle.BLACK_COLOR)
                            .frame(height: 110)
                            .onTapGesture {
                                if self.description == INIT_DESCRIPTION {
                                    self.description = ""
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment:.leading, spacing: 16){
                        
                        HStack{
                            Text("사진 등록")
                                .padding(.vertical, 6)
                            
                            Text("\(photosPickerItems.count)/5")
                        }
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                
                                PhotosPicker("+", selection: $photosPickerItems, maxSelectionCount: 5, selectionBehavior: .ordered)
                                    .font(.system(size: 30))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(CommonStyle.MAIN_COLOR, lineWidth: 2)
                                    )
                                
                                ForEach(0..<images.count, id: \.self) { image in
                                    Image(uiImage: images[image])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(CommonStyle.MAIN_COLOR, lineWidth: 2)
                                        )
                                }
                            }
                        }.scrollIndicators(.hidden)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .onTapGesture {
                    keyboardHandler.hideKeyboard()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .alert(isPresented: $saleVM.registerFailed, content: {
            Alert(title: Text("업로드 실패"), message: Text("작성 내용을 확인해주세요."), dismissButton: .default(Text("확인")))
        })
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: photosPickerItems) { _, _ in
            Task {
                if !images.isEmpty {
                    images.removeAll()
                }
                await addPhotoItems()
            }
        }
        .onReceive(saleVM.registraionSuccess, perform: {
            self.dismiss()
            isLoading = false
            isSuccessUpload = true
        })
        .onReceive(saleVM.authError, perform: {
            isSessionOut = true
        })
        .alert(isPresented: $isSessionOut, content: {
            Alert(title: Text("세션이 만료되었습니다."), dismissButton: .default(Text("확인"), action: {
                SessionManager.shared.isLoggedIn = false
            }))
        })
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
    
    private func addPhotoItems() async {
        for item in photosPickerItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    images.append(image)
                }
            }
        }
    }
}

#Preview {
    SaleView()
}
