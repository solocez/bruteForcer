import RxSwift

protocol Command {
    associatedtype CommandResult

    func execute() -> Single<CommandResult>
}
