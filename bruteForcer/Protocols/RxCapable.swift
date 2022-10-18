import RxSwift

protocol RxCapable {
    var bag: DisposeBag { get }
}
