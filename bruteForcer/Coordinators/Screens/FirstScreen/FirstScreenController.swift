import RxCocoa
import UniformTypeIdentifiers
import RxSwift

final class FirstScreenController: RxViewController, KeyboardDismissableOnTap, UIDocumentPickerDelegate {

    @IBOutlet private weak var wordlistLbl: UILabel!
    @IBOutlet private weak var loadWordsBtn: UIButton!
    @IBOutlet private weak var wordListText: UITextView!
    
    @IBOutlet private weak var alphabetLbl: UILabel!
    @IBOutlet private weak var loadAlphabetBtn: UIButton!
    @IBOutlet private weak var alphabetText: UITextView!
    
    @IBOutlet private weak var targetHostLbl: UILabel!
    @IBOutlet private weak var targetHostText: UITextField!

    @IBOutlet private weak var actionBtn: UIButton!

    private var openingDocumentType: DocumentTypePick = .words
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

        loadWordsBtn.setTitle("Load words", for: .normal)
        loadAlphabetBtn.setTitle("Load alphabet", for: .normal)

        wordListText.layer.borderWidth = 1
        wordListText.layer.borderColor = UIColor.lightGray.cgColor

        alphabetText.layer.borderWidth = 1
        alphabetText.layer.borderColor = UIColor.lightGray.cgColor
    
        actionBtn.setTitle("Force Login Attempts", for: .normal)
    }

    override func setupRxBindings() {
        bindLoader(loadable: viewModel, onCancelled: { [unowned self] in
            self.viewModel.onCancel.onNext(Void())
        })
        bindCredentialsMatherial()
        bindLoadButtons()
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

    func bindLoadButtons() {
        loadWordsBtn.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.openPickDocument(for: .words)
            })
            .disposed(by: bag)

        loadAlphabetBtn.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.openPickDocument(for: .alphabet)
            })
            .disposed(by: bag)
    }
    
    func snapshotDataFromUI() -> FirstScreenViewModelInterface.ActionData {
        let url = URL(string: targetHostText.text ?? "") ?? URL(fileURLWithPath: "")
        return (url, wordListText.text.components(separatedBy: "\n") , alphabetText.text.components(separatedBy: "\n"))
    }

    func bindActionBtn() {
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

// MARK: Opening document logic
private extension FirstScreenController {
    enum DocumentTypePick {
        case words
        case alphabet
    }
    
    func openPickDocument(for docType: DocumentTypePick) {
        openingDocumentType = docType

        let supportedTypes: [UTType] = [.text, .plainText, .utf8PlainText, .utf16ExternalPlainText, .utf16PlainText, .delimitedText, .commaSeparatedText]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }
}

// MARK: UIDocumentPickerDelegate implementation
extension FirstScreenController {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let file = urls.first else { return }

        do {
            let content = try String(contentsOf: file, encoding: String.Encoding.utf8)
            let textView = openingDocumentType == .words ? wordListText : alphabetText
            textView?.text = content
        } catch {
            log.warning(error)
        }
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
