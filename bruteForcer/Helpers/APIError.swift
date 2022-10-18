import Alamofire
import SwiftyJSON

enum JsonKey {
    static let type = "type"
    static let code = "code"
    static let message = "message"
    static let errors = "errors"
    static let content = "content"
}

enum APIErrorType {
    case cancelled
    case alamofireError
    case internalError
    case unknown
}

protocol APIErrorData {
    var code: Int { get }
    var message: String { get }
    var payload: [String: Any] { get }
    var traceId: Any? { get }
}

final class APIError: LocalizedError, CustomDebugStringConvertible {

    var type: APIErrorType = .unknown
    var code: Int = -1
    var message: String = ""
    var payload = [String: Any]()

    var debugDescription: String {
        "\(JsonKey.type): \(JsonKey.code): \(code)\n\(JsonKey.message): \(message)"
    }

    var isCancellation: Bool {
        type == .cancelled
    }

    init(type: APIErrorType) {
        self.type = type
    }

    init(error: Error) {
        handleError(error)
    }

    init(with message: String) {
        self.type = .internalError
        self.code = 1
        self.message = message
    }

    init(json: JSON) {
        let code = json[JsonKey.code].int ?? -1

        let message = json["message"].string ?? "Unspecified message"

        // Pull errors from response JSON
        var errorMessages: [String] = []
        json[JsonKey.errors].forEach { item in
            item.1.dictionary?.forEach({ key, json in
                if let tmp = (json[JsonKey.errors].arrayObject as? [String])?.joined(separator: ", ") {
                    errorMessages.append("\(key): \(tmp)")
                }
            })
        }

        self.type = .internalError
        self.code = code
        self.message = message + (errorMessages.isEmpty ? "" : ("\n" + errorMessages.joined(separator: "; ")))
        self.payload = json.dictionaryValue
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
        type = .alamofireError
        code = afError.responseCode ?? -1
        message = afError.errorDescription ?? afError.localizedDescription
    }
}
