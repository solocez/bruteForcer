import UIKit

extension UITableView {
    func register(cell: UITableViewCell.Type) {
        register(UINib(nibName: cell.nameOfClass, bundle: cell.bundle), forCellReuseIdentifier: cell.identifier)
    }
}
