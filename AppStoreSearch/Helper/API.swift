//
//  API.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/06.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation

enum API {
    /// 검색 결과 리스트 조회
    case search (term: String)
    /// 상세보기 조회
    case lookup (bundleId: String)
    
    static let baseUrl = "https://itunes.apple.com"
    
    var method: HTTPMethod {
        switch self {
        case .search, .lookup:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .search(_):
            return "/search"
        case .lookup(_):
            return "/lookup"
        }
    }
    
    var query: String {
        switch self {
        case .search(let term):
            let encodedTerm = term
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            return "?term=\(encodedTerm ?? String())&country=kr&media=software&limit=50"
        case .lookup(let bundleId):
            return "?bundleId=\(bundleId)&country=kr&media=software"
        }
    }
    
    var urlString: String {
        return API.baseUrl + path + query
    }
    
    func request () -> DataRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return DataRequest(url: url)
    }
}
