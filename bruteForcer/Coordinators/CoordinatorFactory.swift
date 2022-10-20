import UIKit

final class CoordinatorFactory {
    init() {}

    func  applicationCoordinator(window: UIWindow) -> RxBaseCoordinator<Void> {
        ApplicationCoordinator(window: window)
    }

    func router(_ navController: UINavigationController) -> Router {
        RouterImp(rootController: navController)
    }
}
