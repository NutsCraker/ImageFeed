//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 03.04.2023.
//

import Foundation
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
