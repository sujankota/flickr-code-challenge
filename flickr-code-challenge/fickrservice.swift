//
//  fickrservice.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import Foundation

class FlickrService: FlickrServiceProtocol {
    static let shared = FlickrService()
    
    private init() {}
    
    func searchImages(tags: String) async throws -> [FlickrImage] {
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FlickrResponse.self, from: data)
        return response.items
    }
}

struct FlickrResponse: Codable {
    let items: [FlickrImage]
}
