import UIKit

final class LoadingCell: RxTableViewCell {

    @IBOutlet private weak var activity: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activity.startAnimating()
    }

    func setup(with viewModel: LoadingCellViewModelInterface) {
        setupViews()
        setupRxBindings()
    }
}

extension LoadingCell {
    func setupViews() {
    }

    func setupRxBindings() {
    }
}
