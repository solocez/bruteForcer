import RxCocoa
import RxSwift
import RxSwiftExt

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

        actionBtn.setTitle("Force", for: .normal)
    }

    override func setupRxBindings() {
        bindLoader(loadable: viewModel, onCancelled: { [unowned self] in
            self.viewModel.onCancel.onNext(Void())
        })
        bindActionBtn()
    }
}

private extension FirstScreenController {
    func bindActionBtn() {
        //continueBtn.rx.tap.bind(to: viewModel.onContinue).disposed(by: bag)
    }
}
