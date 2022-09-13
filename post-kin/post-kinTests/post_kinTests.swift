//
//  post_kinTests.swift
//  post-kinTests
//
//  Created by isa nur fajar on 08/09/22.
//

import XCTest
@testable import post_kin

class post_kinTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testSuccessFetchPost() async{
        let expectation = XCTestExpectation(description: "Success")
        
        let service = PostClient()
        _ = service.getFeed(.getPost(page: 0))
            .sink(receiveCompletion: { _ in
            }, receiveValue: { item in
                XCTAssertTrue(!item.isEmpty)
                expectation.fulfill()
            })
    }
    
    @MainActor
    func testSuccessFetchUser(){
        let expectation = XCTestExpectation(description: "Success")
        
        let service = PostClient()
        _ = service.getUser(.getUser)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { item in
                XCTAssertTrue(!item.isEmpty)
                expectation.fulfill()
            })
    }

}
