import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    fileprivate var applicationCoordinator: ApplicationCoordinator?
    fileprivate var bag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        Logger.shared.setupSwiftyBeaver()

        let window = UIWindow(windowScene: windowsScene)
        self.window = window
        window.makeKeyAndVisible()
        
        applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator?.start()
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe()
            .disposed(by: bag)
    }
}

