//
//  SearchView.swift
//  hanbat-market
//
//  Created by dongs on 3/27/24.
//

import SwiftUI
import CachedAsyncImage

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var searchVM = SearchVM()
    
    @State private var searchText: String = ""
    @State private var isEmptySearchText: Bool = false
    @State private var articleData: [HomeArticleModel] = []
    @State private var recentSearches: [String] = []
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack(spacing: 0) {
            searchHeader
            
            if searchVM.searchResponse == nil {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18){
                            HStack{
                                Text("최근 검색어")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button("지우기") {
                                    recentSearches.removeAll()
                                    saveRecentSearches()
                                }
                                .font(.system(size: 14))
                                .foregroundStyle(CommonStyle.GRAY_COLOR)
                                .padding(.trailing, 20)
                            }
                            
                            if recentSearches.isEmpty {
                                Text("최근 검색어가 없습니다.")
                            } else {
                                
                                
                                var width = CGFloat.zero
                                var height = CGFloat.zero
                                
                                
                                ZStack(alignment: .topLeading) {
                                    ForEach(recentSearches, id: \.self) { keyword in
                                        recentSearchKeyword(for: keyword)
                                            .padding(.all, 4)
                                            .alignmentGuide(.leading, computeValue: { d in
                                                if (abs(width - d.width) > geometry.size.width)
                                                {
                                                    width = 0
                                                    height -= d.height
                                                }
                                                let result = width
                                                if keyword == self.recentSearches.last! {
                                                    width = 0 //last item
                                                } else {
                                                    width -= d.width
                                                }
                                                return result
                                            })
                                            .alignmentGuide(.top, computeValue: {d in
                                                let result = height
                                                if keyword == self.recentSearches.last! {
                                                    height = 0 // last item
                                                }
                                                return result
                                            })
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 18)
                        
                        VStack (alignment: .leading, spacing: 18){
                            Text("인기 검색어")
                                .fontWeight(.bold)
                            Text("기프티콘")
                            
                        }.frame(maxWidth: geometry.size.width, alignment: .leading)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                
            } else if searchVM.searchResponse!.data.articles.isEmpty {
                ScrollView {
                    VStack{
                        Spacer().frame(height: 50)
                        Image(systemName: "exclamationmark.magnifyingglass")
                            .font(.system(size: 38))
                            .foregroundStyle(CommonStyle.MAIN_COLOR)
                            .padding(.bottom, 10)
                        Text("검색된 상품이 없어요!")
                        Text("다른 검색어를 입력해보세요 :)")
                    }.fontWeight(.medium)
                }.padding(.vertical, 16)
                    .padding(.horizontal, 20)
            } else {
                if articleData.isEmpty {
                    ScrollView {
                        VStack{
                            Spacer().frame(height: 50)
                            ProgressView()
                                .controlSize(.large)
                                .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                            Spacer().frame(height: 30)
                            Text("검색한 상품을 불러오는 중이에요!")
                        }.fontWeight(.medium)
                    }.padding(.vertical, 16)
                        .padding(.horizontal, 20)
                }
                if !articleData.isEmpty{
                    List {
                        ForEach(articleData, id: \.id) { item in
                            NavigationLink(destination: ArticleView(articleId: item.id)) {
                                HStack(spacing: 12) {
                                    CachedAsyncImage(url: URL(string: item.thumbnailFilePath)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 90, height: 90)
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(10)
                                    }
                                    
                                    VStack(alignment:.leading, spacing: 8) {
                                        Text(item.memberNickname)
                                            .font(.system(size: 12))
                                            .foregroundColor(CommonStyle.GRAY_COLOR)
                                        Text("\(item.price)원")
                                            .font(.system(size: 14))
                                            .fontWeight(.bold)
                                            .foregroundColor(CommonStyle.MAIN_COLOR)
                                        Text(item.title)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
        .onAppear {
            loadRecentSearches()
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .onReceive(searchVM.fetchingSearchData, perform: { _ in
            fillContent(with: searchVM.searchResponse!.data.articles)
        })
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func recentSearchKeyword(for keyword: String) -> some View {
        Button(action: {
            searchVM.fetchSearchData(title: keyword)
        }, label: {
            Text(keyword.count > 15 ? "\(keyword.prefix(15))···" : keyword)
            
            Spacer().frame(width: 10)
            
            Button(action: {
                if let index = recentSearches.firstIndex(of: keyword) {
                    recentSearches.remove(at: index)
                    saveRecentSearches()
                }
            }) {
                Image(systemName: "xmark")
            }
        })
        .font(.system(size: 13))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .cornerRadius(30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(CommonStyle.MAIN_COLOR, lineWidth: 1)
        )
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
    
    var searchHeader: some View {
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
            TextField("검색어를 입력하세요.", text: $searchText)
                .font(.system(size: 16))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(CommonStyle.SEARCH_BG_COLOG)
                .cornerRadius(30)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .onSubmit {
                    searchVM.fetchSearchData(title: searchText)
                    saveSearch()
                }
            Spacer()
            Spacer()
            Button {
                if searchText.isEmpty {
                    isEmptySearchText = true
                } else {
                    searchVM.fetchSearchData(title: searchText)
                    saveSearch()
                }
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .foregroundStyle(CommonStyle.BLACK_COLOR)
            .padding(.trailing, 20)
        }
        .alert(isPresented: $isEmptySearchText, content: {
            Alert(title: Text("검색 실패"), message: Text("검색어를 입력하세요."), dismissButton: .default(Text("확인")))
        })
        
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
    
    private func fillContent(with articles: [HomeArticleModel])   {
        Task {
            print("articles", articles)
            articleData = articles
        }
    }
    
    private func saveSearch() {
        if !recentSearches.contains(searchText){
            recentSearches.insert(searchText, at: 0)
        }
        
        saveRecentSearches()
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
        print("recentSearches: \(recentSearches)")
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
    }
}

#Preview {
    SearchView()
}
