//
//  model.swift
//  flickr-code-challenge
//
//  Created by sujan kota on 9/23/24.
//

import Foundation

import Foundation

struct FlickrImage: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, media, description, published, author, tags
        case dateTaken = "date_taken"
    }
    
    static func == (lhs: FlickrImage, rhs: FlickrImage) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.link == rhs.link &&
        lhs.media == rhs.media &&
        lhs.dateTaken == rhs.dateTaken &&
        lhs.description == rhs.description &&
        lhs.published == rhs.published &&
        lhs.author == rhs.author &&
        lhs.tags == rhs.tags
    }
}

struct Media: Codable, Equatable {
    let m: String
}


