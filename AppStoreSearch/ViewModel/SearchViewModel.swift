//
//  SearchViewModel.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/07.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

enum SearchType {
    case local
    case server
}

class SearchViewModel {
    
    init() {
        let lastSearchList = LocalStorage.shared.lastSearchList
        lastSearchList?.forEach({ [weak self] (item) in
            self?.keywordList.append(item.keyword)
        })
    }
    
    var totalCount: Int?
    var searchList: [SearchItemViewModel] = [] {
        didSet {
            totalCount = searchList.count
        }
    }
    var searchType: SearchType = .local
    var keywordList: [String] = []
    var autoCompleteList: [String] = []
    var handler: ((Bool) -> Void)?
    
    var term: String? {
        didSet {
            guard let term = term else {
                return
            }
            
            self.searchList = []
            self.autoCompleteList = []
            
            if searchType == .server {
                API.search(term: term).request()?.responseCodable(SearchModel.self) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let searchModel):
                        searchModel.results?.forEach({ (item) in
                            
                            let itemModel = SearchItemViewModel.init(bundleId: item.bundleId, title: item.trackCensoredName, subTitle: item.sellerName, ratingCount: String.stringForRating(item.userRatingCount ?? 0), averageRating: item.averageUserRating ?? 0.0, icon: item.artworkUrl512, screenshot: item.screenshotUrls)
                            
                            self.searchList.append(itemModel)
                        })
                        
                        if let handler = self.handler {
                            self.keywordList = []
                            LocalStorage.shared.type = .realm
                            LocalStorage.shared.keyword = term
                            let keywordList = LocalStorage.shared.keywordSearchList
                            
                            keywordList?.forEach({ [weak self] (item) in
                                self?.keywordList.append(item.keyword)
                            })
                            handler(true)
                            LocalStorage.shared.keyword = ""
                        }
                        print(self.searchList)
                        
                    case .failure(let error):
                        
                        if let handler = self.handler {
                            handler(false)
                        }
                        print(error.localizedDescription)
                    }
                }
            } else {
                
                LocalStorage.shared.type = .memory
                LocalStorage.shared.keyword = term
                let keywordList = LocalStorage.shared.keywordSearchList
                
                keywordList?.forEach({ [weak self] (item) in
                    self?.autoCompleteList.append(item.keyword)
                })
            }
        }
    }
}

struct SearchItemViewModel {
    let bundleId: String?
    let title: String?
    let subTitle: String?
    let ratingCount: String?
    let averageRating: Double?
    let icon: String?
    let screenshot: [String]?
}
