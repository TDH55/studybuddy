//
//  CSE439_ProjectUITests.swift
//  CSE439_ProjectUITests
//
//  Created by Taylor Howard on 2/6/21.
//

import XCTest

class CSE439_ProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoToCameraPage() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        app.launch()
        let cameraButton = app.buttons["Camera Scan"]
        
        XCTAssert(cameraButton.exists)
        
        cameraButton.tap()
        
        XCTAssert(app.staticTexts["Camera"].exists)
        XCTAssert(app.buttons["Scan"].exists)
        
    }
    
    func testGoToPDFPage() throws {
        let app = XCUIApplication()
        
        app.launch()
        let pdfButton = app.buttons["PDF"]
        
        XCTAssert(pdfButton.exists)
        
        pdfButton.tap()

        XCTAssert(app.staticTexts["PDF"].exists)
        XCTAssert(app.buttons["Upload PDF"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
