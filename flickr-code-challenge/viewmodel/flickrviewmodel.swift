//
//  viewmodel.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import SwiftUI
import Combine

import Foundation

protocol FlickrServiceProtocol {
    func searchImages(tags: String) async throws -> [FlickrImage]
}


// Update FlickrViewModel to use the protocol
class FlickrViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    private let service: FlickrServiceProtocol
    
    init(service: FlickrServiceProtocol = FlickrService.shared) {
        self.service = service
        
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.searchImages(searchText: searchText)
                } else {
                    self?.clearImages()
                }
            }
            .store(in: &cancellables)
    }
    
    private func searchImages(searchText: String) {
        searchTask?.cancel()
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            do {
                let images = try await service.searchImages(tags: searchText)
                await MainActor.run {
                    self.images = images
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.images = []
                }
            }
        }
    }
    
    private func clearImages() {
        searchTask?.cancel()
        images = []
        errorMessage = nil
        isLoading = false
    }
}
