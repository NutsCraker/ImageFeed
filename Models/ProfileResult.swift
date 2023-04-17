//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 14.03.2023.
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

struct PhotoLikeResult: Codable {}
