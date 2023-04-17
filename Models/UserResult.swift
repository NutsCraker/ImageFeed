//
//  UserResult.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 14.03.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageURL
    
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}

struct ProfileImageURL: Codable {
    let small: String
    let medium: String
}
