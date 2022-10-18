import UIKit

class NibLoadingView: UIView {
    // swiftlint:disable:next private_outlet
    @IBOutlet public weak var view: UIView!

    /// Init
    ///
    /// - Parameter frame: frame descript
    override public init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
        configureView()
    }
    
    func configureView() {}

    /// Setup XIB
    private func nibSetup() {
        backgroundColor = .clear

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }

    /// Load XIB
    ///
    /// - Returns: XIBView
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return nibView ?? UIView()
    }
}
