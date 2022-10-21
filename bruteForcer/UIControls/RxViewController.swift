import RxCocoa
import RxSwift

class RxViewController: UIViewController, RxCapable {
    let bag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRxBindings()
    }

    func setupViews() {
        log.warning("Non Implemented!")
    }

    func setupRxBindings() {
        log.warning("Non Implemented!")
    }
}

extension RxViewController {
    func bindLoader(loadable: Loadable, onCancelled: @escaping () -> Void) {
        loadable.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoader(onCancelled: onCancelled) : self?.hideLoader()
            })
            .disposed(by: bag)
    }
}
