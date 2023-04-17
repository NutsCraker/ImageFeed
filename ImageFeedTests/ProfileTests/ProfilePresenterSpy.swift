//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 05.04.2023.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var didExitCalled: Bool = false
    
    func setUI() {
        view?.makeUI()
    }
    
    func exit() {
        didExitCalled = true
    }
    
    func getUrlForProfileImage() -> URL? {
        return URL(string: "https://unsplash.com")
    }
    
    var profileService: ImageFeed.ProfileService
    
    init (profileService: ProfileService ) {
        self.profileService = profileService
    }
    
    
}


