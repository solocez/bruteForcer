import RxCocoa
import RxSwift

final class CommentCell: RxTableViewCell {
    
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var emailLbl: UILabel!
    @IBOutlet private weak var bodyLbl: UILabel!
    
    private var viewModel: CommentCellViewModelInterface!

    func setup(with viewModel: CommentCellViewModelInterface) {
        self.viewModel = viewModel
        setupViews()
        setupRxBindings()
    }
}

private extension CommentCell {
    func setupViews() {
//        nameLbl.text = viewModel.entity.name
//        nameLbl.font = .boldSystemFont(ofSize: 12)
//        
//        emailLbl.text = viewModel.entity.email
//        emailLbl.font = .italicSystemFont(ofSize: 10)
//        
//        bodyLbl.text = viewModel.entity.body
//        bodyLbl.font = .italicSystemFont(ofSize: 10)
    }

    func setupRxBindings() {
    }
}
