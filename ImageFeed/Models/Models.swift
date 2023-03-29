//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 15.03.2023.
//

import Foundation
struct ProfileResult: Decodable {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

 struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
}

struct UserData: Codable {
    let profileImage: ProfileImageURL
    
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}

struct ProfileImageURL: Codable {
    let small: String
    let medium: String
}

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
    //let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
