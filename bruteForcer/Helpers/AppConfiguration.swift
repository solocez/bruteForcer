import Foundation

enum Constants {
    enum Host {
        static let prod = "http://httpbin.org/basic-auth/"
        static let preprod = "http://httpbin.org/basic-auth/"
    }
}

protocol AppConfigurable {
    var host: String { get }
}

final class AppConfiguration: AppConfigurable {

    static var shared = AppConfiguration(host: Constants.Host.preprod)

    let host: String

    private init(host: String) {
        self.host = host
    }
}
