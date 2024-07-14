// TODO: Default header
import AsyncState
import Foundation
import UIKit

@Modeled(___FILEBASENAMEASIDENTIFIER___State.self, ___FILEBASENAMEASIDENTIFIER___ViewModel.self)
final class ___FILEBASENAMEASIDENTIFIER___ViewController: UIViewController, ModeledViewController {
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Storyboards are not supported. Use init(viewModel:)")
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension ___FILEBASENAMEASIDENTIFIER___ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        startObservingState(renderImmediately: true)
    }
}

// MARK: - Subviews

extension ___FILEBASENAMEASIDENTIFIER___ViewController {
    ///  Prepare subviews for state rendering
    private func setupSubviews() {
        // TODO: Add subviews
    }

    @MainActor
    func render(_: State) {
        // TODO: Apply state to view
    }
}
