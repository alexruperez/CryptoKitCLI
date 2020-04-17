import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(CryptoKitCLITests.allTests)
    ]
}
#endif
