import Foundation
import RxSwift

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
