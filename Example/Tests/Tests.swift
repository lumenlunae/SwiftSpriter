import UIKit
import XCTest
import SwiftSpriter
@testable import Pods_SwiftSpriter_Example
class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParserRead() {
        let parser = SconParser(fileName: "BasicTests")
        let animationData = parser?.animationData()
        XCTAssert(animationData != nil, "Pass")
    }
    
    func testParserPerformance() {
        
        self.measure() {
            let parser = SconParser(fileName: "BasicTests")
            _ = parser?.animationData()
        }
    }
    
}
