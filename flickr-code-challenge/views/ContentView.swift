//
//  ContentView.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding()
                    .background(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                
                ZStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground).opacity(0.8))
                    } else if !viewModel.searchText.isEmpty && !viewModel.images.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(viewModel.images) { image in
                                    NavigationLink(destination: ImageDetailView(image: image)) {
                                        ImageThumbnail(imageURL: image.media.m)
                                    }
                                    .accessibilityLabel(image.title)
                                }
                            }
                            .padding()
                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage)
                    } else if viewModel.searchText.isEmpty {
                        EmptyStateView()
                    } else {
                        NoResultsView()
                    }
                }
            }
            .navigationTitle("Flickr Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .accessibilityLabel("Clear search")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No results found")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}



#Preview {
    ContentView()
}
