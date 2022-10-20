import RxSwift

final class ApplicationCoordinator: RxBaseCoordinator<Void> {

    private var window: UIWindow

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
    #warning("Localisation is required")
    func runMainFlow() {
        let vm = FirstScreenViewModel()
        let firstScreen = ScreenFactory().createFirstScreen(viewModel: vm)
        vm.modelResult
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { modelResult in
                switch modelResult {
                case .success(let loginResult):
                    let msg = loginResult.0 ? "Logged in with \(loginResult.1):\(loginResult.2)" : "Failed to login"
                    firstScreen.toPresent()?.showAlert(title: "Login Attempt", message: msg)
                case .failure(let error):
                    log.error(error)
                }
            }, onError: { error in
                log.error(error)
            })
            .disposed(by: bag)
        router.setRootModule(firstScreen)
    }

    static func createRouterForHorizontalFlows() -> Router {
        CoordinatorFactory().router(UINavigationController(rootViewController: UIViewController()))
    }
}
