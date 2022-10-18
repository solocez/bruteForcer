import RxCocoa
import RxSwift

protocol FirstScreenViewModelInterface: Loadable {
    var words: BehaviorRelay<[String]> { get }
    var alphabet: BehaviorRelay<[String]> { get }

    var onCancel: PublishSubject<Void> { get }
    var onAction: PublishSubject<(URL, [String], [String])> { get }
}

final class FirstScreenViewModel: FirstScreenViewModelInterface, ViewModelBase {
    typealias ViewModelResultType = (Int/*lower bound*/, Int/*upper bound*/)

    var modelResult = PublishRelay<Result<ViewModelResultType, APIError>>()

    //let words: BehaviorRelay<[String]>
    lazy var words: BehaviorRelay<[String]> = {
        let (wordsLoaded, _) = credentials.loadWordsAlphabet()
        return BehaviorRelay<[String]>(value: wordsLoaded)
    }()
    lazy var alphabet: BehaviorRelay<[String]> = {
        let (_, alphabetLoaded) = credentials.loadWordsAlphabet()
        return BehaviorRelay<[String]>(value: alphabetLoaded)
    }()
    
    let onCancel = PublishSubject<Void>()
    let onAction = PublishSubject<(URL, [String], [String])>()

    var maxComments = BehaviorRelay<Int>(value: Constants.maximumComments)

    var isLoading = BehaviorRelay<Bool>(value: false)

    private var lower = -1
    private var upper = -1
    private var bag = DisposeBag()
    private var bagForFetch = DisposeBag()
    @Inject private var api: RestAPI
    @Inject private var credentials: CredentialsManager
    private var isCancelled = false

    init() {
//        let (wordsLoaded, alphabetLoaded) = credentials.loadWordsAlphabet()
//        words = BehaviorRelay<[String]>(value: wordsLoaded)
//        alphabet = BehaviorRelay<[String]>(value: alphabetLoaded)
        
        onCancel
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.isCancelled = true
                self.bagForFetch = DisposeBag()
            })
            .disposed(by: bag)
    }
}

extension FirstScreenViewModel {
    func simulateDelayInterval() -> Observable<Void> {
        Observable.just(()).delay(.seconds(Constants.intervalToWaitBeforeResult), scheduler: MainScheduler.asyncInstance)
    }

    func fetchComments() -> Single<ViewModelResultType> {
        Observable.combineLatest(simulateDelayInterval(), _fetchComments().asObservable())
            .map { $0.1 }
            .asSingle()
    }

    func _fetchComments() -> Single<ViewModelResultType> {
        Single<ViewModelResultType>.create { [unowned self]  single in
            for idx in self.lower...self.upper {
                if self.isCancelled { break }
            }
            single(.success((self.lower, self.upper)))
            return Disposables.create()
        }
    }
}
