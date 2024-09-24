//
//  flickr_code_challengeTests.swift
//  flickr-code-challengeTests
//
//  Created by sujan kota on 9/23/24.
//

import Testing
import Foundation
@testable import flickr_code_challenge

import Testing
@testable import flickr_code_challenge

struct FlickrViewModelTests {
    
    @Test
    func testSearchImagesSuccess() async throws {
        // Given
        let mockService = MockFlickrService()
        let viewModel = FlickrViewModel(service: mockService)
        let expectedImages = [FlickrImage(title: "Test Image", link: "https://example.com", media: Media(m: "https://example.com/image.jpg"), dateTaken: "2023-09-23", description: "Test description", published: "2023-09-23T12:00:00Z", author: "Test Author", tags: "test")]
        mockService.searchImagesResult = .success(expectedImages)
        
        // When
        viewModel.searchText = "test"
        
        // Then
        try await Task.sleep(for: .milliseconds(600))  // Wait for debounce
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.images == expectedImages)
    }
    
    @Test
    func testSearchImagesFailure() async throws {
        // Given
        let mockService = MockFlickrService()
        let viewModel = FlickrViewModel(service: mockService)
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockService.searchImagesResult = .failure(expectedError)
        
        // When
        viewModel.searchText = "test"
        
        // Then
        try await Task.sleep(for: .milliseconds(600))  // Wait for debounce
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == expectedError.localizedDescription)
        #expect(viewModel.images.isEmpty)
    }
    
    @Test
    func testClearImages() async throws {
        // Given
        let mockService = MockFlickrService()
        let viewModel = FlickrViewModel(service: mockService)
        viewModel.images = [FlickrImage(title: "Test Image", link: "https://example.com", media: Media(m: "https://example.com/image.jpg"), dateTaken: "2023-09-23", description: "Test description", published: "2023-09-23T12:00:00Z", author: "Test Author", tags: "test")]
        viewModel.errorMessage = "Previous error"
        viewModel.isLoading = true
        
        // When
        viewModel.searchText = ""
        
        // Then
        try await Task.sleep(for: .milliseconds(600))  // Wait for debounce
        
        #expect(viewModel.images.isEmpty)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isLoading)
    }
}

// MARK: - Mock Service

class MockFlickrService: FlickrServiceProtocol {
    var searchImagesResult: Result<[FlickrImage], Error>?
    
    func searchImages(tags: String) async throws -> [FlickrImage] {
        guard let result = searchImagesResult else {
            fatalError("searchImagesResult not set")
        }
        switch result {
        case .success(let images):
            return images
        case .failure(let error):
            throw error
        }
    }
}
