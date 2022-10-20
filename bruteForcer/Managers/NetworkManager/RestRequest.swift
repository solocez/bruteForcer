import Alamofire

struct RestRequest {
    var host: String?
    var method: HTTPMethod
    var headers: [String: String]?

    init(method: HTTPMethod, headers: [String: String]? = nil, host: String? = nil) {
        self.host = host
        self.method = method
        self.headers = headers
    }
}
