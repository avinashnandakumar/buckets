import XCTest

import bucketsTests

var tests = [XCTestCaseEntry]()
tests += bucketsTests.allTests()
XCTMain(tests)