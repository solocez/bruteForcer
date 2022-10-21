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
                            single(.failure(AppError(error: error)))
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
        let fullURL = "\(request.host ?? AppConfiguration.shared.host)"
        let urlParams: [String: Any] = ["version": "1", "os": "ios"]

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

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("ios", forHTTPHeaderField: "x-client-os")
        urlRequest.addValue(Bundle.main.appVersion ?? "unknown", forHTTPHeaderField: "x-client-version")
        
        // Setup Headers
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}

