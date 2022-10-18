import RxCocoa

protocol Loadable {
    var isLoading: BehaviorRelay<Bool> { get }
}
