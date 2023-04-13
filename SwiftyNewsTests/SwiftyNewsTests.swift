import XCTest
@testable import SwiftyNews

class SwiftyNewsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetUserLocationAndConvertStateName() throws {
        let vc = HomeViewController()
        
        vc.getUserLocation()
        XCTAssertEqual(vc.userLocation, "Columbus+Ohio", "Not equal")
    }
    
    func testConvertEmail() throws {
        let vc = NewsViewController()
        
        var actual = vc.convertEmail(email: "shin.810@osu.edu")
        XCTAssertEqual("shin,810@osu,edu", actual)
        
        actual = vc.convertEmail(email: "champion_adam@gmail.com")
        XCTAssertEqual("champion_adam@gmail,com", actual)
        
        actual = vc.convertEmail(email: "1.2.,3.as,f.da.bas,dcda.,s@gmail.com")
        XCTAssertEqual("1,2,,3,as,f.da,bas,dcda,,s@gmail,com", actual)
    }
}
