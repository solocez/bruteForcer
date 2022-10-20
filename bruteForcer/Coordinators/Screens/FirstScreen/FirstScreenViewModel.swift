import RxCocoa
import RxSwift

protocol FirstScreenViewModelInterface: Loadable {
    typealias ActionData = (URL, [String], [String])

    // Out
    var words: BehaviorRelay<[String]> { get }
    var alphabet: BehaviorRelay<[String]> { get }
    var host: BehaviorRelay<URL> { get }

    // In
    var onCancel: PublishSubject<Void> { get }
    var onAction: PublishSubject<ActionData> { get }
}

final class FirstScreenViewModel: FirstScreenViewModelInterface, ViewModelBase {
    typealias ViewModelResultType = (Bool/*is logged in*/, String/*Login*/, String/*Password*/)

    var modelResult = PublishRelay<Result<ViewModelResultType, APIError>>()

    lazy var words: BehaviorRelay<[String]> = {
        let (wordsLoaded, _) = credentials.loadWordsAlphabet()
        return BehaviorRelay<[String]>(value: wordsLoaded)
    }()
    lazy var alphabet: BehaviorRelay<[String]> = {
        let (_, alphabetLoaded) = credentials.loadWordsAlphabet()
        return BehaviorRelay<[String]>(value: alphabetLoaded)
    }()
    lazy var host: BehaviorRelay<URL> = {
        if let host = credentials.loadHost() {
            return BehaviorRelay(value: host)
        }
        let defaultHost = URL(string: AppConfiguration.shared.host) ?? URL(fileURLWithPath: "")
        return BehaviorRelay(value: defaultHost)
    }()
    
    let onCancel = PublishSubject<Void>()
    let onAction = PublishSubject<ActionData>()

    var isLoading = BehaviorRelay<Bool>(value: false)

    private var bag = DisposeBag()
    @Inject private var api: RestAPI
    @Inject private var credentials: CredentialsManager
    private var isCancelled = false

    private let operationsQueue = OperationQueue()
    private var operationsChunk = DispatchSemaphore(value: Constants.defaultSimultaneousOperationsCount)
    
    init() {
        operationsQueue.name = "Login Attempts Queue"
        operationsQueue.qualityOfService = .utility

        onAction
            .asObservable()
            .subscribe(onNext: { [unowned self] loginData in
                self.isCancelled = false
                self.isLoading.accept(true)
    
                self.credentials.persist(target: loginData.0)
                self.credentials.persist(words: loginData.1, alphabet: loginData.2)

                self.operationsQueue.addOperation { [unowned self] in
                    self.doLoginAttempts(with: loginData)
                    self.isLoading.accept(false)
                }
            }, onError: { [unowned self] error in
                log.error(error)
                self.isLoading.accept(false)
            })
            .disposed(by: bag)

        onCancel
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.cancelAttempts()
            })
            .disposed(by: bag)
    }
}

extension FirstScreenViewModel {
    func doLoginAttempts(with data: ActionData) {
        // Goal is to try to login. Trying each possible Login with each possible Password
        // Try all possible Logins
        data.1.forEach { itemLogin in
            let stringsMixer = StringMixer(initial: itemLogin)
            stringsMixer.mixWith(content: data.2) { loginToTry in
                // Try All possible passwords
                data.1.forEach { itemPassword in
                    let stringsMixer = StringMixer(initial: itemPassword)
                    stringsMixer.mixWith(content: data.2) { passwordToTry in
                        // We have here Login and Password variants to try
                        if !isCancelled {
                            triggerTryLogin(host: data.0.absoluteString, login: loginToTry, password: passwordToTry)
                        }
                        return isCancelled
                    }
                }
                return isCancelled
            }
        }
        if !isCancelled {
            modelResult.accept(Result.success((false, "", "")))
        }
    }

    func triggerTryLogin(host: String, login: String, password: String) {
        operationsChunk.wait()
        log.debug("TRYING TO LOGIN WITH \(login):\(password)")

        let loginAttempt = LoginAttempt(host: host
                                        , user: login
                                        , password: password
                                        , completion: { [weak self] isLoggedIn in
            self?.operationsChunk.signal()
            if isLoggedIn {
                log.debug("SUCCESSFULLY LOGGED IN WITH \(login):\(password)")
                self?.cancelAttempts()
                self?.modelResult.accept(Result.success((true, login, password)))
            }
        })

        operationsQueue.addOperation(loginAttempt)
    }

    func cancelAttempts() {
        isCancelled = true
        isLoading.accept(false)
        operationsQueue.cancelAllOperations()
        operationsChunk.signal()
    }
}

final class LoginAttempt: Operation, RxCapable {
    enum LoginAttemptState: String {
        case notStarted
        case inProgress
        case loggedIn
        case loginFailed
    }
    
    var attemptState: LoginAttemptState = .notStarted {
        willSet(newValue) {
            willChangeValue(forKey: attemptState.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: attemptState.rawValue)
        }
    }
    
    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { attemptState == .inProgress }
    override var isFinished: Bool {
        if isCancelled { return true }
        return attemptState == .loggedIn || attemptState == .loginFailed
    }
    
    private let command: BasicAuthenticationCommand
    private let completion: (Bool) -> ()
    var bag = DisposeBag()

    init(host: String, user: String, password: String, completion: @escaping (Bool) -> ()) {
        self.completion = completion
        command = BasicAuthenticationCommand(host: host, user: user, password: password)
    }

    override func start() {
        guard !isCancelled else { return }
    
        attemptState = .inProgress
        
        command.execute()
            .subscribe(onSuccess: { [unowned self] isAuthenticated in
                if isAuthenticated {
                    self.attemptState = .loggedIn
                } else {
                    self.attemptState = .loginFailed
                }

                self.completion(self.attemptState == .loggedIn)
            }, onFailure: { [unowned self] error in
                self.attemptState = .loginFailed
                log.error(error)
                self.completion(false)
            })
            .disposed(by: bag)
    }
    
    override func cancel() {
        super.cancel()
        bag = DisposeBag()
        attemptState = .loginFailed
    }
}
