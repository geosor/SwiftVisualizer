import XCTest
@testable import SwiftVisualizerFramework

class SwiftVisualizerFrameworkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftVisualizerFramework().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftVisualizerFrameworkTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
