//
//  bruteForcerTests.swift
//  bruteForcerTests
//
//  Created by Zakhar Sukhanov on 17.10.2022.
//

import XCTest
import RxSwift
@testable import bruteForcer

final class bruteForcerTests: XCTestCase {

    let bag = DisposeBag()
    @Inject var api: RestAPI

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

    func testBase64() throws {
        let matherial = "hello:there"
        XCTAssertEqual(matherial.toBase64().fromBase64(), matherial)
    }

    func testBasicAuthenticationCommand() throws {
        let stateExp = expectation(description: "stateExp")
        let command = BasicAuthenticationCommand(host: AppConfiguration.shared.host + "foo1/bar", user: "foo1", password: "bar")
        command.execute()
            .subscribe(onSuccess: { isAuthenticated in
                if isAuthenticated {
                    stateExp.fulfill()
                } else {
                    XCTFail("Failed: not authenticated")
                }
            }, onFailure: { error in
                XCTFail("Failed: \(error.localizedDescription)")
            })
            .disposed(by: bag)
        wait(for: [stateExp], timeout: 3)
    }
}
