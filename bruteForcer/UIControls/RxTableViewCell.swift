import RxCocoa
import RxSwift

class RxTableViewCell: UITableViewCell, RxCapable {
    var bag = DisposeBag()

    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    override open func prepareForReuse() {
        super.prepareForReuse()

        bag = DisposeBag()
    }
}
