import Foundation
import RxSwift

protocol KeyboardDismissableOnTap: AnyObject {
    var dismissableView: UIView { get }

    func hideKeyboardWhenTappedAround(bag: DisposeBag)
}

extension KeyboardDismissableOnTap where Self: RxViewController {
    var dismissableView: UIView {
        view
    }

    func hideKeyboardWhenTappedAround(bag: DisposeBag) {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        dismissableView.addGestureRecognizer(tap)
        tap.rx.event
            .bind(onNext: { [weak self] _ in
                self?.dismissableView.endEditing(true)
            })
            .disposed(by: bag)
    }
}
