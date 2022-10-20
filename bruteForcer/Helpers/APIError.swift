import Alamofire

protocol APIErrorData {
    var code: Int { get }
    var message: String { get }
}

final class APIError: LocalizedError, CustomDebugStringConvertible {

    var code: Int = -1
    var message: String = ""

    var debugDescription: String {
        "\(code):\(message)"
    }

    init(error: Error) {
        handleError(error)
    }
}

private extension APIError {
    func handleError(_ error: Error) {
        switch error {
        case let error as AFError:
            handleAFError(with: error)
        default:
            message = error.localizedDescription
        }
    }

    func handleAFError(with afError: AFError) {
        code = afError.responseCode ?? -1
        message = afError.errorDescription ?? afError.localizedDescription
    }
}
