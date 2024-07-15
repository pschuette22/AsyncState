// TODO: Default header comment
import AsyncState
import Foundation

final class SignUpViewModel: ViewModeling {
  // -- State Definition --
  typealias State = SignUpState
  private(set) var state: State {
    didSet {
      openStateStream.send(state)
    }
  }

  // -- State Streaming --
  private var openStateStream = OpenAsyncBroadcast<State>()
  var stateStream: any AsyncBroadcast<State> {
    openStateStream
  }

  required init(_ initialState: State = .init()) {
    state = initialState
  }
}

// MARK: - ViewModeling

extension SignUpViewModelViewModel {
  @MainActor
  func currentState() -> State {
    state
  }
}
