import Foundation

enum Constants {
    enum Host {
        static let prod = "https://jsonplaceholder.typicode.com/"
        static let preprod = "https://jsonplaceholder.typicode.com/"
    }

    static let maximumComments =  500
    static let intervalToWaitBeforeResult = 3
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
