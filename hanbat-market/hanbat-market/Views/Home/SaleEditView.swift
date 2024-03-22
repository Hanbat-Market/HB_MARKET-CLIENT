//
//  SaleEditView.swift
//  hanbat-market
//
//  Created by dongs on 3/22/24.
//

import SwiftUI
import PhotosUI

struct SaleEditView: View {
    
    let articleId: Int
    
    @StateObject var saleVM = SaleVM()
    @StateObject private var keyboardHandler = KeyboardUtils()
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var itemName: String = ""
    @State private var price: String = ""
    @State private var description: String = INIT_DESCRIPTION
    @State private var tradingPlace: String = ""
    
    @State private var images: [UIImage] = []
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var isSuccessUpload: Bool = false
    
    @State private var isLoading = true
    @State private var isDeleting = false
    
    var body: some View {
        VStack {
            
            HStack(spacing: 0){
                Button{
                    self.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                }.padding(.leading, 20)
                
                Spacer()
                Spacer()
                Text("상품 수정하기")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                HStack(spacing:0){
                
                    Button(action: {
                        if !isSuccessUpload && !isLoading {
                            saleVM.editArticle(articleId: articleId, title: title, price: Int(price) ?? 0, itemName: itemName, description: description, tradingPlace: tradingPlace, selectedImages: images)
                        }})  {
                            Text("수정")
                                .foregroundStyle(CommonStyle.MAIN_COLOR)
                                .padding(.trailing, 16)
                            
                        }
                    
                    Button(action: {
                        isDeleting.toggle()
                    })  {
                        Text("삭제")
                            .foregroundStyle(.red)
                            .padding(.trailing, 20)
                        
                    }
                }
                .padding(.vertical, 12)
            }
            
            
            if isLoading {
                ScrollView{
                    VStack{
                        Spacer().frame(height: 50)
                        ProgressView()
                            .controlSize(.large)
                            .padding(.bottom, 20)
                        Text("상품을 불러오는 중입니다...")
                            .fontWeight(.medium)
                    }
                    
                }
            } else{
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
                        AuthInput(placeholder: "만날 장소를 입력해주세요.", textInput: $tradingPlace, keyboardType: .default)
                        
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
                        }.scrollIndicators(.hidden)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, keyboardHandler.keyboardHeight)
                .onTapGesture {
                    keyboardHandler.hideKeyboard()
                }
            }
        }
        .onAppear{
            saleVM.fetchArticle(articleId: articleId)
            
        }
        .onReceive(saleVM.successFetchingArticle, perform: {
            fillContent(with: saleVM.article)
        })
        .ignoresSafeArea(edges: .bottom)
        .alert(isPresented: $saleVM.editArticleFailed, content: {
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
        .alert(isPresented: $isDeleting, content: {
            Alert(title: Text("로그아웃"), message: Text("정말 로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("취소"), action: {
                isDeleting = false
            }), secondaryButton: .cancel(Text("확인"), action: {
                saleVM.deleteArticle(articleId: articleId)
            }))
        })
        .onReceive(saleVM.editSuccess, perform: {
            self.dismiss()
            isSuccessUpload = true
        })
        .onReceive(saleVM.successDeletingArticle, perform: { _ in
            self.dismiss()
        })
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
    
    private func fillContent(with article: ArticleModel?)   {
        guard let article = article else { return }
        Task {
            title = article.title
            itemName = article.itemName
            price = "\(article.price)"
            description = article.description
            tradingPlace = article.tradingPlace
            
            var loadedImages: [UIImage] = []
            
            for imagePath in article.filePaths {
                if let imageURL = URL(string: imagePath) {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: imageURL)
                        if let image = UIImage(data: data) {
                            loadedImages.append(image)
                        }
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
            }
            
            DispatchQueue.main.async {
                images = loadedImages
                isLoading = false
            }
        }
        
    }
}


#Preview {
    SaleEditView(articleId: 5)
}

