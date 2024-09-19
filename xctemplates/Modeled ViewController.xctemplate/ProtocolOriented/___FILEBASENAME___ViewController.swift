// ___FILEHEADER___

import AsyncState
import Foundation
import UIKit

@Modeled(___VARIABLE_productName:identifier___State.self, interface:___VARIABLE_productName:identifier___ViewModelProtocol.self)
final class ___FILEBASENAME___<ViewModel: ___VARIABLE_productName:identifier___ViewModelProtocol>: UIViewController {
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

extension ___FILEBASENAME___ {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        startObservingState(renderImmediately: true)
    }
}

// MARK: - Subviews

extension ___FILEBASENAME___ {
    ///  Prepare subviews for state rendering
    private func setupSubviews() {
        // TODO: Add subviews
    }

    @MainActor
    func render(_ state: State) {
        // TODO: Apply state to view
    }
}
