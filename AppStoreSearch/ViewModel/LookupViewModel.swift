//
//  LookupViewModel.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/07.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

enum LookupAppInfoExpandState {
    case collapsed
    case expanded
}

class LookupViewModel {
    var lookupList: [LookupItemViewModel] = []
    var handler: ((Bool) -> Void)?
    var bundleId: String? {
        didSet {
            guard let bundleId = bundleId else {
                return
            }
            lookupList = []
            API.lookup(bundleId: bundleId).request()?.responseCodable(LookupModel.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let lookupModel):
                    lookupModel.results?.forEach({ (item) in
                        let itemModel = LookupItemViewModel.init(title: item.trackCensoredName, subTitle: item.sellerName, ratingCount: String.stringForRating(item.userRatingCount ?? 0), averageRating: item.averageUserRating ?? 0.0, screenshot: item.screenshotUrls, releaseDescryption: item.releaseNotes, releaseDate: item.currentVersionReleaseDate, version: item.version, genre: item.primaryGenreName, age: item.contentAdvisoryRating, icon: item.artworkUrl512, descryption: item.description, sellerName: item.sellerName, fileSizeBytes: item.fileSizeBytes, genres: item.genres, supportedDevices: item.supportedDevices, languageCodesISO2A: item.languageCodesISO2A )
                        self.lookupList.append(itemModel)
                    })
                    
                    if let handler = self.handler {
                        handler(true)
                    }
                    print(self.lookupList)
                    
                case .failure(let error):
                    
                    if let handler = self.handler {
                        handler(false)
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct LookupItemViewModel {
    let title: String?
    let subTitle: String?
    let ratingCount: String?
    let averageRating: Double?
    let screenshot: [String]?
    let releaseDescryption: String?
    let releaseDate: String?
    let version : String?
    let genre: String?
    let age: String?
    let icon: String?
    let descryption: String?
    let sellerName: String?
    let fileSizeBytes: String?
    let genres: [String]?
    let supportedDevices: [String]?
    let languageCodesISO2A: [String]?
    
    func makeAppInfoViewModel() -> [LookupAppInfoViewModel] {
        let sellerName = self.sellerName ?? ""
        let fileSizeBytes = self.fileSizeBytes ?? "0"
        let fileSizeBytesString = String.convertMBFormatter(Int64(fileSizeBytes) ?? 0)
        let ageGrade = self.age
        
        
        let sellerTitle = "제공자"
        let sizeTitle = "크기"
        let categoryTitle = "카테고리"
        let compatibilityTitle = "호환성"
        let langTitle = "언어"
        let ageTitle = "연령 등급"
        let copyrightTitle = "저작권"
        let dot = "."
        let results: [LookupAppInfoViewModel] = [
            
            LookupAppInfoViewModel.init(title: sellerTitle, subtitle: sellerName, desc: ""),
            LookupAppInfoViewModel.init(title: sizeTitle, subtitle: fileSizeBytesString, desc: ""),
            LookupAppInfoViewModel.init(title: categoryTitle, subtitle: self.makeGenre(), desc: ""),
            LookupAppInfoViewModel.init(title: compatibilityTitle, subtitle: UIDevice.current.model, desc: self.makeCompatibility(), useExpand: true),
            LookupAppInfoViewModel.init(title: langTitle, subtitle: String.init(format:"\(languageCodesISO2A?.first ?? "한국어") %@", (languageCodesISO2A?.count ?? 0 > 1) ? "외 \(languageCodesISO2A?.count ?? 0)" : "" ), desc: self.makeLanguege(), useExpand: true),
            LookupAppInfoViewModel.init(title: ageTitle, subtitle: ageGrade, desc: ""),
            LookupAppInfoViewModel.init(title: copyrightTitle, subtitle: "@" + sellerName + dot, desc: "")
            
        ]
        
        return results
    }
    
    fileprivate func makeGenre () -> String {
        var genre = ""
        if let genres = self.genres {
            var title = ""
            var subTitle = ""
            for (index, genre) in genres.enumerated() {
                if index == 0 {
                    title = genre
                } else {
                    subTitle = genre
                }
            }
            genre = String.init(format: "\(title) %@",(subTitle == "") ? "": ": \(subTitle)")
        }
        return genre
    }
    
    fileprivate func makeCompatibility () -> String {
        var compatibitity = ""
        if let devices = self.supportedDevices {
            compatibitity = devices.joined(separator: ", ")
        }
        return compatibitity
    }
    
    fileprivate func makeLanguege () -> String {
        var languege = ""
        if let lang = self.languageCodesISO2A {
            languege = lang.joined(separator: ", ")
        }
        return languege
    }
}

struct LookupAppInfoViewModel {
    let title: String?
    let subtitle: String?
    let desc: String?
    var useExpand: Bool = false
    var expandState: LookupAppInfoExpandState = .collapsed
}
