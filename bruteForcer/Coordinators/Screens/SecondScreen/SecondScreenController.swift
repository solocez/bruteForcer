import RxCocoa
import RxSwift

final class SecondScreenController: RxViewController {

    @IBOutlet private weak var commentsTbl: UITableView!
    
    private let viewModel: SecondScreenViewModelInterface

    init(viewModel: SecondScreenViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: SecondScreenController.identifier, bundle: SecondScreenController.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        commentsTbl.scrollToRow(at: IndexPath(row: viewModel.lowerBound, section: 0), at: .top, animated: false)
    }

    override func setupViews() {
        setupCommentsTable()
    }

    override func setupRxBindings() {
        bindLoader(loadable: viewModel, onCancelled: {
            // TODO:
        })
        viewModel.freshDataArrived
            .subscribe(onNext: { [unowned self] freshState in
                guard let visibleCells = self.commentsTbl.indexPathsForVisibleRows?.compactMap({ $0 }) else {
                    return
                }
                //let cellsToReload = visibleCells.filter { freshState.comments[SecondScreenController.map(ui: $0.row)] != nil }
                //self.commentsTbl.reloadRows(at: cellsToReload, with: .automatic)
            })
            .disposed(by: bag)
    }
}

private extension SecondScreenController {
    static func map(ui idx: Int) -> Int {
        idx + 1
    }

    func setupCommentsTable() {
        commentsTbl.dataSource = self
        let cells: [UITableViewCell.Type] = [
            CommentCell.self,
            LoadingCell.self
        ]
        cells.forEach(commentsTbl.register)
    }
}

// MARK: - UITableViewDataSource
extension SecondScreenController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.commentsNumber
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let entity = viewModel.entityFor(index: SecondScreenController.map(ui: indexPath.row)) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
                return UITableViewCell()
            }
            cell.setup(with: CommentCellViewModel(entity: entity))
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else {
            return UITableViewCell()
        }
        cell.setup(with: LoadingCellViewModel())
        return cell
    }
}
