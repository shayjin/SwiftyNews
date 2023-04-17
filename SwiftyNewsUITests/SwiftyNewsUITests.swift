//
//  SwiftyNewsUITests.swift
//  SwiftyNewsUITests
//
//  Created by Shay on 2/22/23.
//

import XCTest
import CoreLocation

class SwiftyNewsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangingTab() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.tabBars.buttons["Profile"].isSelected)
        
        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.tabBars.buttons["Search"].isSelected)
        
        app.tabBars.buttons["Home"].tap()
        XCTAssertTrue(app.tabBars.buttons["Home"].isSelected)
    }
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Profile"].tap()
        
        XCTAssertTrue(app.tabBars.buttons["Profile"].isSelected)
        
        if "Profile" == app.staticTexts["status"].label {
            app.buttons["logout"].tap()
        }
    
        var username = app.textFields["username"]
        username.tap()
        username.typeText("shin.810@osu.edu")
        
        var password = app.textFields["password"]
        password.tap()
        password.typeText("abc123")
        
        app.buttons["login"].tap()
        app.buttons["logout"].tap()
        
        XCTAssertEqual("Log In", app.staticTexts["status"].label, "error")
    }
    
    func testChangingNewsType() throws {
        let app = XCUIApplication()
        app.launch()
        
        let segmentControl = app.segmentedControls["newsType"]

        segmentControl.buttons.element(boundBy: 2).tap()
        XCTAssertTrue(segmentControl.buttons.element(boundBy: 2).isSelected)
        
        segmentControl.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(segmentControl.buttons.element(boundBy: 1).isSelected)
        
        segmentControl.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(segmentControl.buttons.element(boundBy: 0).isSelected)
    }

}
