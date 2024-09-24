//
//  image.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import SwiftUI

struct ImageThumbnail: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}
