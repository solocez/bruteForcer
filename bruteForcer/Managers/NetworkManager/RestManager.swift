import Alamofire
import RxSwift

enum RestManagerError: Error {
    case badInput
    case incorrectUrl
}

protocol RestAPI {
    func execute(_ request: RestRequest) -> Single<Data>
}

final class RestManager: RestAPI {
    init() {}

    func execute(_ request: RestRequest) -> Single<Data> {
        Single<Data>.create { [unowned self] single in
            do {
                let urlRequest = try self.prepareURLRequest(for: request)
                AF.request(urlRequest)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success(let value):
                            single(.success(value))
                        case .failure(let error):
                            single(.failure(APIError(error: error)))
                        }
                    }
            } catch {
                log.error(error)
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}

extension RestManager {
    func prepareURLRequest(for request: RestRequest) throws -> URLRequest {
        // Compose the url
        let fullURL = "\(request.host ?? AppConfiguration.shared.host)\(request.path)"
        var urlParams: [String: Any] = ["version": request.version, "os": "ios"]
        var httpBody: Data?
        // Working with parameters
        switch request.parameters {
        case .body(let params)?:
            httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        case .url(let params)?:
            // Parameters are part of the url
            urlParams.merge(params, uniquingKeysWith: { _, last in last })
        default: break
        }

        let queryParams = urlParams.map { element in
            URLQueryItem(name: element.key, value: "\(element.value)")
        }

        guard var components = URLComponents(string: fullURL) else {
            throw RestManagerError.badInput
        }

        components.queryItems = queryParams
        
        guard let url = components.url else {
            throw RestManagerError.incorrectUrl
        }

        // Setup HTTP method
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = httpBody
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("ios", forHTTPHeaderField: "x-client-os")
        urlRequest.addValue(Bundle.main.appVersion ?? "unknown", forHTTPHeaderField: "x-client-version")
        
        // Setup Headers
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}

