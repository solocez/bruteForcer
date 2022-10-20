import Foundation

extension NSObject {
    var nameOfClass: String {
        NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }

    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    class var bundle: Bundle {
        Bundle(for: self)
    }
}
