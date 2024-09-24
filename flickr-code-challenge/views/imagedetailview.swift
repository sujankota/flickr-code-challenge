//
//  detailview.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import SwiftUI

struct ImageDetailView: View {
    let image: FlickrImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: URL(string: image.media.m)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                .accessibilityLabel("Image: \(image.title)")
                
                Text(image.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let attributedDescription = attributedStringFromHTML(image.description) {
                    Text(attributedDescription)
                        .font(.body)
                } else {
                    Text("No description available")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "person.circle")
                    Text("By: \(parseAuthor(image.author))")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Published: \(formattedDate(image.published))")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text("Tags: \(image.tags)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Image Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
        return dateString
    }
    
    private func parseAuthor(_ author: String) -> String {
        if let nameRange = author.range(of: "\"([^\"]*)\"", options: .regularExpression) {
            return String(author[nameRange]).trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        }
        return author
    }
    
    private func attributedStringFromHTML(_ htmlString: String) -> AttributedString? {
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }
        
        do {
            // Convert HTML to NSAttributedString
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            let nsAttributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
            // Convert NSAttributedString to Swift's AttributedString
            let attributedString = try AttributedString(nsAttributedString)
            
            return attributedString
        } catch {
            print("Error parsing HTML: \(error)")
            return nil
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("Start searching for images")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}
