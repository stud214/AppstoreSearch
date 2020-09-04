//
//  DataRequest.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/06.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//


import UIKit

enum HTTPMethod: CustomStringConvertible {
    case GET
    case POST
    
    var description: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

enum APIError: Error {
    case Unknown
    case decodeFailed
}

class DataRequest {
    var url: URL
    var session: URLSession? = nil
    
    init(url: URL) {
        self.url = url
    }
    
    func responseCodable<T: Codable>(_ type: T.Type = T.self, completion: @escaping (Result<T, Error>) -> Void) {
        self.applicationNetworkActivityIndicatorVisible(true)
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        let task = session?.dataTask(with: url) { data, urlresponse, error in
            guard let httpURLResponse = urlresponse as? HTTPURLResponse
                , 200..<300 ~= httpURLResponse.statusCode, let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.Unknown))
                }
                self.applicationNetworkActivityIndicatorVisible(false)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.decodeFailed))
            }
            self.applicationNetworkActivityIndicatorVisible(false)
        }
        task?.resume()
    }
    
    private func applicationNetworkActivityIndicatorVisible(_ visible: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        }
    }
}
