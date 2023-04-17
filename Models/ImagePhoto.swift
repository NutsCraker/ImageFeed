//
//  ImagePhoto.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 17.03.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let welcomeDescription: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case urls = "urls"
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
