import XCTest
@testable import bruteForcer

final class bruteForcerCredentialsManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCredentialsManager() throws {
        let manager = CredentialsManagerImpl()
        manager.wipeAllRecords()
        var creds = manager.loadWordsAlphabet()
        XCTAssert(creds.0.isEmpty)
        XCTAssert(creds.1.isEmpty)

        manager.persist(words: ["hi", "there"], alphabet: ["i0", "qwerty"])
        creds = manager.loadWordsAlphabet()
        XCTAssert(!creds.0.isEmpty)
        XCTAssert(!creds.1.isEmpty)

        manager.wipeAllRecords()
    }
}
