//
//  SearchModel.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/06.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation

struct SearchModel: Codable {
    let resultCount: Int64?
    let results: [SearchItemModel]?
}

struct SearchItemModel: Codable {
    let bundleId: String?
    let trackCensoredName: String?
    let sellerName: String?
    var artworkUrl512: String?
    var screenshotUrls: [String]?
    let averageUserRating: Double?
    let userRatingCount: Int64?
}
