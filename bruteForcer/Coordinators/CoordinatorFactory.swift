import UIKit

final class CoordinatorFactory {
    init() {}

    #warning("Worth to hide using Type Erasuere")
    func  applicationCoordinator(window: UIWindow) -> RxBaseCoordinator<Void> {
        ApplicationCoordinator(window: window)
    }

    func router(_ navController: UINavigationController) -> Router {
        RouterImp(rootController: navController)
    }
}
