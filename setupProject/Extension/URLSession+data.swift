
//
//  URLSession+data.swift
//  setupProject
//
//  Created by Илья Дышлюк on 02.05.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError(Error)
    case noData
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, 
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let statusCodeError = NetworkError.httpStatusCode(statusCode)
                    print("[dataTask]: Network Error - \(statusCodeError)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                let urlRequestError = NetworkError.urlRequestError(error)
                print("[dataTask]: Network Error - \(urlRequestError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                let urlSessionError = NetworkError.urlSessionError
                print("[dataTask]: Network Error - \(urlSessionError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    let decodingError = NetworkError.decodingError(error)
                    print("[objectTask]: Network Error - \(decodingError)")
                    completion(.failure(decodingError))
                }
            case .failure(_):
                let urlSessionError = NetworkError.urlSessionError
                print("[objectTask]: Network Error - \(urlSessionError)")
                completion(.failure(urlSessionError))
            }
        }
        return task
    }
}
