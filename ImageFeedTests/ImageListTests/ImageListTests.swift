//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Alexander Farizanov on 06.04.2023.
//

import XCTest
@testable import ImageFeed


final class ImageListTests: XCTestCase {
    
    func testSetLike () {
        //given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImageListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.setLike()
        
        //then
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable1() {
        //given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImageListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        //then
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
    
}
