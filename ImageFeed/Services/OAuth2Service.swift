//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 27.02.2023.
//

import Foundation

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            guard let newValue = newValue else { return }
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = object(for: request) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest,
                        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        return urlSession.objectTask(for: request, completion: { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/oauth/token"
                                   + "?client_id=\(AccessKey)"
                                   + "&&client_secret=\(SecretKey)"
                                   + "&&redirect_uri=\(RedirectURI)"
                                   + "&&code=\(code)"
                                   + "&&grant_type=authorization_code",
                                   httpMethod: "POST",
                                   baseURL: URL(string: "https://unsplash.com")!)
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
