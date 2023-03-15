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
