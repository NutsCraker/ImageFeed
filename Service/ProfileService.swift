//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 07.03.2023.
//

import Foundation

class ProfileService {
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
    private (set) var profile: Profile?
    
    private func convertToProfile(_ ProfileResult: ProfileResult) -> Profile {
        return Profile(userName: ProfileResult.userName, name: "\(ProfileResult.firstName) \(ProfileResult.lastName)", loginName: "@\(ProfileResult.userName)", bio: ProfileResult.bio ?? "")
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: profilePath, httpMethod: get)
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
}

