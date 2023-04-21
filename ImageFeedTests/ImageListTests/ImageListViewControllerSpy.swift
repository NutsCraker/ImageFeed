//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 06.04.2023.
//

import UIKit
@testable import ImageFeed


final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImageListPresenterProtocol?
    
    var photos: [ImageFeed.Photo]
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.chekFilledList(indexPath)
    }
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func setLike() {
        presenter?.setLike(photoId: "test", isLike: true) {result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
