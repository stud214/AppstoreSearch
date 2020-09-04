//
//  DataSource.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/07.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum WriteType {
    case memory
    case realm
}

class LocalStorage {
    static let shared = LocalStorage()
    
    var type: WriteType = .memory
    
    var lastSearchList: Results<RecentKeyWordModel>? {
        
        get {
            let realm = try? Realm()
            return realm?.objects(RecentKeyWordModel.self)
        }
    }
    
    var keywordSearchList: Results<RecentKeyWordModel>? {
        get {
            let realm = try? Realm()
            
            guard let keyword = keyword else {
                return nil
            }
            return realm?.objects(RecentKeyWordModel.self).filter("keyword CONTAINS %@", keyword)
        }
    }
    
    var keyword: String? {
        didSet {
            guard let value = keyword, keyword != "" else {
                return
            }
            
            if type == .realm {
               let recentKeyWordModel = RecentKeyWordModel(keyword:value)
               let realm = try? Realm()
               try? realm?.write {
                   realm?.add(recentKeyWordModel, update: .modified)
               }
            }
        }
    }
}

