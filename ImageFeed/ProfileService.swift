//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 15.03.2023.
//

import Foundation

final class ProfileService {
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
    private (set) var profile: Profile?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private (set) var avatarURL: String?
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private func convertToProfile(_ ProfileResult: ProfileResult) -> Profile {
         return Profile(userName: ProfileResult.userName,
                        name: "\(ProfileResult.firstName) \(ProfileResult.lastName)",
                        loginName: "@\(ProfileResult.userName)",
                        bio: ProfileResult.bio ?? "")
     }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        var request = URLRequest.makeHTTPRequest (path: "me", httpMethod: "GET", baseURL: defaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result{
            case .success(let currentUser):
                let newProfile = self.convertToProfile(currentUser)
                self.profile = newProfile
                completion(.success(newProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        self.task = task
        task.resume()
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
       if task != nil {
           task?.cancel()
       }
        var request = URLRequest.makeHTTPRequest(path: "users/\(userName)", httpMethod: "GET")
        if let token = oAuth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<UserData, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let smallURL):
                let newSmallURL = smallURL.profileImage.medium
                self.avatarURL = newSmallURL
                print(newSmallURL)
                completion(.success(newSmallURL))
                NotificationCenter.default.post(name: ProfileService.DidChangeNotification, object: self,
                    userInfo: ["URL": newSmallURL])
            case .failure(let error):
                completion(.failure(error))
            }
        })
     self.task = task
       task.resume()
   }
}


