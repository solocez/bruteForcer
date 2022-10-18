//
//  bruteForcerTests.swift
//  bruteForcerTests
//
//  Created by Zakhar Sukhanov on 17.10.2022.
//

import XCTest
@testable import bruteForcer

final class bruteForcerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringMixer() throws {
        let variants = ["ii", "1i", "2i", "hi", "h1", "h2"]
        StringMixer(initial: "hi").mixWith(content: ["i12"]) { variant in
            NSLog(variant)
            XCTAssertFalse(variants.filter { $0 == variant }.isEmpty)
            return false
        }
    }
}
