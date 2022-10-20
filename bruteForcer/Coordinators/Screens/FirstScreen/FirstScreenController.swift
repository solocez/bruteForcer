import RxCocoa
import RxSwift

#warning("Rename Screen")
final class FirstScreenController: RxViewController, KeyboardDismissableOnTap {

    @IBOutlet private weak var wordlistLbl: UILabel!
    @IBOutlet private weak var wordListText: UITextView!
    
    @IBOutlet private weak var alphabetLbl: UILabel!
    @IBOutlet private weak var alphabetText: UITextView!
    
    @IBOutlet private weak var targetHostLbl: UILabel!
    @IBOutlet private weak var targetHostText: UITextField!

    @IBOutlet private weak var actionBtn: UIButton!

    private let viewModel: FirstScreenViewModelInterface

    init(viewModel: FirstScreenViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: FirstScreenController.identifier, bundle: FirstScreenController.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #warning("Localisation is required")
    override func setupViews() {
        hideKeyboardWhenTappedAround(bag: bag)

        wordlistLbl.text = "Wordlist:"
        alphabetLbl.text = "Alphabet:"
        targetHostLbl.text = "Target Host to login:"

        wordListText.layer.borderWidth = 1
        wordListText.layer.borderColor = UIColor.lightGray.cgColor

        alphabetText.layer.borderWidth = 1
        alphabetText.layer.borderColor = UIColor.lightGray.cgColor
    
        actionBtn.setTitle("Force", for: .normal)
    }

    override func setupRxBindings() {
        bindLoader(loadable: viewModel, onCancelled: { [unowned self] in
            self.viewModel.onCancel.onNext(Void())
        })
        bindCredentialsMatherial()
        bindActionBtn()
    }
}

private extension FirstScreenController {
    func bindCredentialsMatherial() {
        viewModel.words
            .map { $0.joined(separator: "\n") }
            .bind(to: wordListText.rx.text)
            .disposed(by: bag)
        viewModel.alphabet
            .map { $0.joined(separator: "\n") }
            .bind(to: alphabetText.rx.text)
            .disposed(by: bag)
        viewModel.host
            .map { $0.absoluteString }
            .bind(to: targetHostText.rx.text)
            .disposed(by: bag)
    }

    func snapshotDataFromUI() -> FirstScreenViewModelInterface.ActionData {
        let url = URL(string: targetHostText.text ?? "") ?? URL(fileURLWithPath: "")
        return (url, wordListText.text.components(separatedBy: "\n") , alphabetText.text.components(separatedBy: "\n"))
    }

    func bindActionBtn() {
        #warning("TODO: minimum 2 lines at wordlist")
        Observable.combineLatest(targetHostText.rx.text.asObservable() , wordListText.rx.text.asObservable(), alphabetText.rx.text.asObservable())
            .map { !($0.0?.isEmpty ?? true) && !($0.1?.isEmpty ?? true) && !($0.2?.isEmpty ?? true)}
            .bind(to: actionBtn.rx.isEnabled)
            .disposed(by: bag)
        
        actionBtn.rx.tap
            .map { [unowned self] _ in self.snapshotDataFromUI() }
            .bind(to: viewModel.onAction)
            .disposed(by: bag)
    }
}
