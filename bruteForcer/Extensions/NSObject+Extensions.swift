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

    static var className: String {
        String(describing: self)
    }
    
    // Heap/Reference type
    static func addressHeap<T: AnyObject>(object: T) {
        let message = String(format: "Address of \(type(of: object)) is %p",
                             unsafeBitCast(object,
                                           to: Int.self))
        log.debug(message)
    }
    
    // Struct/Value type
    static func addressStack(object: UnsafeRawPointer) {
        let message = String(format: "Address of \(type(of: object)) is %p", Int(bitPattern: object))
        log.debug(message)
    }
}
