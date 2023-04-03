//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 04.03.2023.
//

import Foundation

final class OAuth2Service {
    private var lastCode: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
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
        let request = authTokenRequest(code: code)
        let task = object(for: request) {[weak self] result in
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
        task.resume()
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest,
                        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request, completion: {(result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/oauth/token"
                                   + "?client_id=\(accessKey)"
                                   + "&&client_secret=\(secretKey)"
                                   + "&&redirect_uri=\(redirectURI)"
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

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

// MARK: - Network Connection

private enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fullfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: {data, respone, error in
            if let data = data,
               let respone = respone,
               let statusCode = (respone as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fullfillCompletion(.success(data))
                } else {
                    fullfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fullfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fullfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }          
}
