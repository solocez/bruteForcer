import Alamofire

protocol APIError {
    var code: Int { get }
    var message: String { get }
}

final class AppError: LocalizedError, CustomDebugStringConvertible, APIError {

    var code: Int = -1
    var message: String = ""

    var debugDescription: String {
        "\(code):\(message)"
    }

    init(error: Error) {
        handleError(error)
    }
}

private extension AppError {
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
