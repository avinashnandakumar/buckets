import XCTest
@testable import buckets

final class bucketsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(buckets().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
