import RxCocoa

protocol ViewModelBase {
    associatedtype ViewModelResultType

    var modelResult: PublishRelay<Result<ViewModelResultType, AppError>>  { get }
}
