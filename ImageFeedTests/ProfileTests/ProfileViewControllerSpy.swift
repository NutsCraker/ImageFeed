//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 05.04.2023.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var profileName = UILabel()
    var profileContact = UILabel()
    var profileAbout = UILabel()
    var didMakeUICalled: Bool = false
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    func makeUI() {
        didMakeUICalled = true
    }
    
    func showAlert() {
        presenter?.exit()
    }
    
    
}
