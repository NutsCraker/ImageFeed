//
//  Constants.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 19.02.2023.
//

import Foundation

let AccessKey = "nLyX5EYcRsJuIC_YeN2NcJfCIJ0lIlEY2t_Azeg-ay0"
let SecretKey = "HmE48f8FNyAkHL4Ni5XiHXBB1Yra3bwNOuN2Hzm13Rw"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let profilePath = "me"
let photosPath = "photos"
let get = "GET"
let post = "POST"
let delete = "DELETE"

var DefaultBaseURL: URL {
    guard let url = URL(string: "https://api.unsplash.com/") else {
        preconditionFailure("Unable to construct DefaultBaseURL")
    }
    return url
}

let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 authURLString: unsplashAuthorizeURLString)
    }
}
