// TODO: Default header
import AsyncState
import Foundation
import UIKit

@Modeled(SignUpState.self, SignUpViewModel.self)
final class SignUpViewController: UIViewController, ModeledViewController {
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

extension SignUpViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupSubviews()
    startObservingState(renderImmediately: true)
  }
}

// MARK: - Subviews

extension SignUpViewController {
  ///  Prepare subviews for state rendering
  private func setupSubviews() {
    // TODO: Add subviews
  }

  @MainActor
  func render(_: State) {
    // TODO: Apply state to view
  }
}
