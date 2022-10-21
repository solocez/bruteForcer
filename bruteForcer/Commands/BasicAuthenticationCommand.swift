import RxSwift
import RxCocoa

struct BasicAuthenticationCommand: Command {
    typealias CommandResult = Bool

    var bag = DisposeBag()

    private let host: String
    private let user: String
    private let password: String

    @Inject private var api: RestAPI

    init(host: String, user: String, password: String) {
        self.host = host
        self.user = user
        self.password = password
    }

    func execute() -> Single<CommandResult> {
        let matherial = user + ":" + password
        return api.execute(RestRequest(method: .get
                                       , headers: ["Authorization": "Basic \(matherial.toBase64())"]
                                       , host: host))
        .flatMap { responseData in
            do {
                let result = try JSONDecoder().decode(BasicAuthenticationResponse.self, from: responseData)
                return Observable.just(result.authenticated).asSingle()
            } catch {
                log.error(error)
                return Observable.error(error).asSingle()
            }
        }
    }
}

struct BasicAuthenticationResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case authenticated
        case user
    }
    
    let authenticated: Bool
    let user: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authenticated = try container.decode(Bool.self, forKey: .authenticated)
        self.user = try container.decode(String.self, forKey: .user)
    }
}
