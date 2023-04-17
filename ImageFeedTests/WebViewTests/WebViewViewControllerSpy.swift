//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 03.04.2023.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var viewDidLoadCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        viewDidLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
