//
//  ImageListPresenter.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanovв on 06.04.2023.
//

import Foundation
@testable import ImageFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var imagesListService: ImageFeed.ImagesListService
    var didFetchPhotosCalled: Bool = false
    var didSetLikeCallSuccess: Bool = false
    
    func fetchPhotosNextPage() {
        didFetchPhotosCalled = true
    }
    
    func chekFilledList(_ indexPath: IndexPath) {
        fetchPhotosNextPage()
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didSetLikeCallSuccess = true
    }
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
}
