import UIKit

protocol Router: Presentable {
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable?)
}
