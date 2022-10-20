import Alamofire

#warning("Remove non used fields")
struct RestRequest {
    var host: String?
    var path: String
    var method: HTTPMethod
    var parameters: RequestParameters?
    var version: Double
    var headers: [String: String]?

    init(path: String
         , method: HTTPMethod
         , parameters: RequestParameters? = nil
         , version: Double = 2.0
         , headers: [String: String]? = nil
         , host: String? = nil) {
        self.host = host
        self.path = path
        self.method = method
        self.parameters = parameters
        self.version = version
        self.headers = headers
    }
}

enum RequestParameters {
    case body([String: Any])
    case url([String: Any])
}
