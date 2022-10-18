import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

class Logger {
    static let shared = Logger()

    func setupSwiftyBeaver() {
        let console = ConsoleDestination()
        console.asynchronously = false
        log.addDestination(console)
    }
}
