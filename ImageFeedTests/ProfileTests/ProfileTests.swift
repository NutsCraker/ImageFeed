//
//  ProfileTest.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 05.04.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testGetUrlForProfileImage() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        
        //when
        let url = presenter.getUrlForProfileImage()?.absoluteString
        
        //then
        XCTAssertEqual(url, "https://unsplash.com")
    }
    
    func testExitFromProfile() {
        //given
        let profileService = ProfileService()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.showAlert()
        
        //then
        XCTAssertTrue(presenter.didExitCalled)
    }
    
    func testLoadProfileInfo() {
        //given
        let profileService = ProfileService()
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy(profileService: profileService)
        view.presenter = presenter
        presenter.view = view
        
        //when
        presenter.setUI()
        
        //then
        XCTAssertTrue(view.didMakeUICalled)
    }
}
