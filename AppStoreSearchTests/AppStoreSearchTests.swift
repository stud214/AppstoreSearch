//
//  AppStoreSearchTests.swift
//  AppStoreSearchTests
//
//  Created by Hyun BnS on 2020/08/06.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import XCTest
@testable import Realm
@testable import RealmSwift
@testable import AppStoreSearch

class AppStoreSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let timeout:TimeInterval = 30
    
    func testSearch() throws {
        let exp = XCTestExpectation.init(description: "testSearch")
        let viewModel = SearchViewModel.init()
        viewModel.searchType = .server
        viewModel.term = "카카오"
        
        viewModel.handler = { (status) in
            if status {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: timeout)
    }
    
    func testLookup() throws {
        let exp = XCTestExpectation.init(description: "testLookup")
        
        let viewModel = LookupViewModel()
        viewModel.bundleId = "com.kakaobank.channel"
        viewModel.handler = { (status) in
            if status {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: timeout)
    }
    
    func testLoacalStorage() throws {
        let recentKeyWordModel = RecentKeyWordModel()
        recentKeyWordModel.keyword = "카카오"
        let realm = try Realm()
        try realm.write {
            realm.add(recentKeyWordModel, update: .modified)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
