import RxSwift

final class ApplicationCoordinator: RxBaseCoordinator<Void> {

    var window: UIWindow

    @Inject private var api: RestAPI

    init(window: UIWindow) {
        self.window = window

        let router = ApplicationCoordinator.createRouterForHorizontalFlows()
        
        window.rootViewController = router.toPresent()
        window.makeKeyAndVisible()
        
        super.init(router: router)
    }

    override func start() -> Single<Void> {
        Single<Void>.create { [unowned self] _ in
            DispatchQueue.main.async { [unowned self] in
                self.runMainFlow()
            }
            return Disposables.create()
        }
    }
}

private extension ApplicationCoordinator {
    func runMainFlow() {
        let vm = FirstScreenViewModel()
        vm.modelResult
            .asObservable()
            .subscribe(onNext: { [unowned self] modelResult in
                switch modelResult {
                case .success(let fetchedEntities):
                    self.openSecondScreen(lowerBound: fetchedEntities.0, upperBound: fetchedEntities.1)
                case .failure(let error):
                    if error.isCancellation {
                        log.debug("OPERATION CANCELLED")
                    } else {
                        log.error(error)
                    }
                }
            }, onError: { error in
                log.error(error)
            })
            .disposed(by: bag)
        let firstScreen = ScreenFactory().createFirstScreen(viewModel: vm)
        router.setRootModule(firstScreen)
    }

    func openSecondScreen(lowerBound: Int, upperBound: Int) {
        let vm = SecondScreenViewModel(lowerBound: lowerBound, upperBound: upperBound)
        let secondScreen = ScreenFactory().createSecondScreen(viewModel: vm)
        router.push(secondScreen)
    }

    static func createRouterForHorizontalFlows() -> Router {
        CoordinatorFactory().router(UINavigationController(rootViewController: UIViewController()))
    }
}
