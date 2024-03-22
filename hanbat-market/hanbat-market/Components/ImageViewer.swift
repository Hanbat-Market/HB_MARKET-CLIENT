//
//  ImageViewer.swift
//  hanbat-market
//
//  Created by dongs on 3/22/24.
//

import SwiftUI

struct ImageViewer: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
        } placeholder: {
            ProgressView()
        }
    }
}
