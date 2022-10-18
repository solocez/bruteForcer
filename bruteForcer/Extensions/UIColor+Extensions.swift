import UIKit

extension UIColor {
    convenience init(w white: CGFloat, a alpha: CGFloat = 1) {
        self.init(white: white / 255, alpha: alpha)
    }
}
