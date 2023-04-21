//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 27.02.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
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

extension OAuth2Service {
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        //Логика для предотвращения гонки
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        //формирование URLRequest на получение token
        guard let request = authTokenRequest(code: code) else { return }
        
        //создание URLSessionDataTask на получение token
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com") else { return nil }
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standart.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standart.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standart.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: url)
    }
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


// MARK: - HTTP Request
//extension URLRequest {
//    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
//        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
//        request.httpMethod = httpMethod
//        return request
//    }
//}

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
