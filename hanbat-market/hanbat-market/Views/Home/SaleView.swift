//
//  SaleView.swift
//  hanbat-market
//
//  Created by dongs on 3/19/24.
//

import SwiftUI
import PhotosUI
import MapKit

let INIT_DESCRIPTION = "상품에 대한 설명을 작성해주세요.\n설명을 자세히 적을수록 구매자가 신뢰할 수 있는 게시글이 완성돼요."

struct SaleView: View {
    
    @StateObject var saleVM = SaleVM()
    
    @State private var title: String = ""
    @State private var itemName: String = ""
    @State private var price: String = ""
    @State private var description: String = INIT_DESCRIPTION
    @State private var tradingPlace: String = ""
    
    @State private var images: [UIImage] = []
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            
            BackNavigationBar(navTitle: "상품 판매하기", customButtonAction: {
                print("완료")
                saleVM.register(title: title, price: Int(price) ?? 0, itemName: itemName, description: description, tradingPlace: tradingPlace, selectedImages: images)
            }, customButtonText: "완료")
            
            ScrollView {
                
                VStack(alignment:.leading, spacing: 16){
                    Text("제목")
                        .padding(.leading, 6)
                    AuthInput(placeholder: "제목을 입력해주세요.", textInput: $title, keyboardType: .default)
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading, spacing: 16){
                    Text("상품명")
                        .padding(.leading, 6)
                    AuthInput(placeholder: "상품명을 입력해주세요.", textInput: $itemName, keyboardType: .default)
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading, spacing: 16){
                    Text("가격 (원)")
                        .padding(.leading, 6)
                    // TODO: 가격을 INT로 형변환해서 전송하기
                    AuthInput(placeholder: "가격을 입력해주세요.", textInput: $price, keyboardType: .numberPad)
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading, spacing: 16){
                    Text("희망 거래 장소")
                        .padding(.leading, 6)
                    
                    AuthInput(placeholder: "만날 장소를 입력해주세요.", textInput: $tradingPlace, keyboardType: .default)
                    
                }
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading, spacing: 16){
                    Text("상품 설명")
                        .padding(.leading, 6)
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
                    Text("사진 등록")
                        .padding(.leading, 6)
                    
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
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: photosPickerItems) { _, _ in
            Task {
                if !images.isEmpty {
                    images.removeAll()
                }
                await addPhotoItems()
            }
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
        print("images", images)
    }
}

#Preview {
    SaleView()
}
