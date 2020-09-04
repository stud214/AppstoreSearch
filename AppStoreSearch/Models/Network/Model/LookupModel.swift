//
//  LookupModel.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/07.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation

struct LookupModel: Codable {
    let resultCount: Int64?
    let results: [LookupItemModel]?
}

struct LookupItemModel: Codable {
    let trackCensoredName: String?
    let averageUserRating: Double?
    let userRatingCount: Int64?
    let sellerName: String?
    let wrapperType: String?
    let artistName: String?
    let artistId: Int64?
    let primaryGenreId: Int64?
    let primaryGenreName: String?
    let isGameCenterEnabled: Bool?
    let kind: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let contentAdvisoryRating: String?
    let currentVersionReleaseDate: String?
    let minimumOsVersion: String?
    let releaseNotes: String?
    let description: String?
    var artworkUrl512: String?
    var screenshotUrls: [String]
    let version: String?
    let genres: [String]?
    let supportedDevices: [String]?
    
}






