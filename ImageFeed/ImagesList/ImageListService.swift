//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 28.03.2023.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var page: Int?
    private var perPage = 10
    static let shared = ImagesListService()
    
    
    
    private func makePhoto(_ photoResult: [PhotoResult]) {
        for i in photoResult {
            let photo = Photo(id: i.id, size: CGSize(width: Double(i.width), height: Double(i.height)), welcomeDescription: i.welcomeDescription, thumbImageURL: i.urls.thumb, largeImageURL: i.urls.full, isLiked: i.isLiked)
            photos.append(photo)
        }
    }
    
    func fetchPhotosNextPage() {//_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard var page = page else {
            return page = 1
        }
        page += 1
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: "\(photosPath)?page=\(page)&&per_page=\(perPage)", httpMethod: "GET")
        if let token = oAuth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                DispatchQueue.main.async {
                    self.makePhoto(photosResult)
                }
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
            case .failure(_):
                break
            }
            
        })
        self.task = task
        task.resume()
    }
    
    
}
