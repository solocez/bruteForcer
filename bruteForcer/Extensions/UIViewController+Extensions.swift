import RxCocoa
import RxSwift

final fileprivate class SpinnerTapRecognizer: UITapGestureRecognizer {
    var onTapped: (()->Void)? = nil
}

extension UIViewController {
    /// Returns the name of a class
    static var identifier: String {
        var identifier = String(describing: self)
        // If a class used with generic it returns whole name with generic
        // like ClassName<Generic>, to avoid this, here is cutting
        // only first part - class name
        if let cuttedIndex = identifier.firstIndex(of: "<") {
            identifier = String(identifier[..<cuttedIndex])
        }
        return identifier
    }
    
    var identifier: String {
        type(of: self).identifier
    }
}

extension UIViewController {
    func showLoader(onCancelled: @escaping () -> Void) {
        let spinner = SpinnerViewController()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)

        let tapRecognizer = SpinnerTapRecognizer(target: self, action: #selector(didTapView(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.onTapped = onCancelled
        spinner.view.addGestureRecognizer(tapRecognizer)
    }

    @objc fileprivate func didTapView(_ sender: SpinnerTapRecognizer) {
        hideLoader()
        sender.onTapped?()
    }

    func hideLoader(completion: (() -> Void)? = nil) {
        children.forEach { viewController in
            if viewController is SpinnerViewController {
                UIView.animate(withDuration: 0.2, animations: {
                    viewController.view.alpha = 0
                }, completion: { _ in
                    viewController.removeChildViewController()
                })
            }
        }
        completion?()
    }
}

extension UIViewController {
    func removeChildViewController() {
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
        view.layoutIfNeeded()
    }
}
