//
//  UIImageView+Download .swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/07.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation
import UIKit

enum UIImageError: Error {
    case loadFailed
}

extension UIImageView {
    
    func setImage(_ url: URL, placeholder: UIImage?, contentMode mode: UIView.ContentMode = .scaleAspectFit, cache: URLCache? = nil, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        contentMode = mode
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion(.success(image))
            }
        } else {
            DispatchQueue.main.async() { [weak self] in
                self?.image = placeholder
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                    let mimeType = response.mimeType, mimeType.hasPrefix("image"),
                    let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = image
                        completion(.success(image))
                    }
                } else {
                    completion(.failure(UIImageError.loadFailed))
                }
            }).resume()
        }
    }
}
