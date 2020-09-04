//
//  RecentKeyWordModel.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/06.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RecentKeyWordModel: Object, Codable{
    @objc dynamic var keyword: String = ""

    enum CodingKeys: String, CodingKey {
        case keyword = "term"
    }
    
    override class func primaryKey() -> String? {
        return "keyword"
    }
    
    convenience init(keyword: String) {
        self.init()
        self.keyword = keyword
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container =  try decoder.container(keyedBy: CodingKeys.self)
        keyword = try container.decode(String.self, forKey: .keyword)
    }
}
