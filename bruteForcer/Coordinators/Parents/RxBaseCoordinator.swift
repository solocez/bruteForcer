import RxSwift

// https://benoitpasquier.com/integrate-coordinator-pattern-in-rxswift/
// https://medium.com/better-programming/reactive-mvvm-and-the-coordinator-pattern-done-right-88248baf8ca5
open class RxBaseCoordinator<ResultType>: RxCapable {

    public var isPopulated: Bool {
        !childCoordinators.isEmpty
    }

    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()

    var bag = DisposeBag()
    private(set) var router: Router

    init(router: Router) {
        self.router = router
    }

    @discardableResult
    func coordinate<T>(to coordinator: RxBaseCoordinator<T>) -> Single<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onSuccess: { [weak self, unowned coordinator] _ in
                self?.release(coordinator: coordinator)
            }, onError: { [weak self, unowned coordinator] err in
                log.error(err)
                self?.release(coordinator: coordinator)
            })
    }

    func start() -> Single<ResultType> {
        fatalError("start() method must be implemented at child coordinator")
    }
    
    func addChild(coordinator: RxBaseCoordinator) {
        store(coordinator: coordinator)
    }
    
    func resetCoordinator(newRouter: Router? = nil) {
        childCoordinators.removeAll()
        if let newRouter = newRouter {
            self.router = newRouter
        }
    }
    
    func remove(coordinator: RxBaseCoordinator) {
        release(coordinator: coordinator)
    }
    
    // MARK: - Private

    private func store<T>(coordinator: RxBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func release<T>(coordinator: RxBaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
}
