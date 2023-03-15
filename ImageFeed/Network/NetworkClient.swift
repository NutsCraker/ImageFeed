//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 15.03.2023.
//

import Foundation

private enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}


extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let fullfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: {data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fullfillCompletion(.success(result))
                        } catch {
                            fullfillCompletion(.failure(error))
                        }
                        } else {
                            fullfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        }
                        }else if let error {
                            fullfillCompletion(.failure(NetworkError.urlRequestError(error)))
                        } else {
                            fullfillCompletion(.failure(NetworkError.urlSessionError))
                        }
                        })
                        task.resume()
                        return task
                    }
}

