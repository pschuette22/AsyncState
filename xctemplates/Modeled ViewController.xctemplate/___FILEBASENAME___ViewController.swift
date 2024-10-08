// ___FILEHEADER___

import AsyncState
import Foundation
import UIKit

@Modeled(___VARIABLE_productName: identifier___State.self, ___VARIABLE_productName: identifier___ViewModel.self)
final class ___FILEBASENAMEASIDENTIFIER___: UIViewController {
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

extension ___FILEBASENAMEASIDENTIFIER___ {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        startObservingState(renderImmediately: true)
    }
}

// MARK: - Subviews

extension ___FILEBASENAMEASIDENTIFIER___ {
    ///  Prepare subviews for state rendering
    private func setupSubviews() {
        // TODO: Add subviews
    }

    @MainActor
    func render(_ state: State) {
        // TODO: Apply state to view
    }
}
