import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(bucketsTests.allTests),
    ]
}
#endif