//
//  CSE439_ProjectTests.swift
//  CSE439_ProjectTests
//
//  Created by Taylor Howard on 2/6/21.
//

import XCTest
@testable import CSE439_Project

class CSE439_ProjectTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    //Tests the method that converts the scanned string from camera input into an array for speed reader display
    func testLongStringToArray() throws {
        let inputLink = InputLink(method: .Camera)
        let longString = "This is the long string for the test"
        let correctArray = ["This", "is", "the", "long", "string", "for", "the", "test"]
        XCTAssertEqual(inputLink.convertStringToArray(text: longString), correctArray)
    }
    
    func testCalculateWPMInterval() throws {
        let inputLink = InputLink(method: .Camera)
        let wordsPerMinute: Float = 120
        XCTAssertEqual(inputLink.calculateWPM(wpm: wordsPerMinute), 0.5)
    }

}
