import UIKit

final class ScreenFactory {
    init() {}

    func createFirstScreen(viewModel: FirstScreenViewModelInterface) -> Presentable {
        FirstScreenController(viewModel: viewModel)
    }
}
