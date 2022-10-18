import Foundation

public extension Bundle {
    func bundleValue<T>(forKey key: String) -> T? {
        object(forInfoDictionaryKey: key) as? T
    }

    var appVersion: String? {
        bundleValue(forKey: "CFBundleShortVersionString") ?? ""
    }
}
