// TODO: Default header comment
import AsyncState
import Foundation

final class ___FILEBASENAME___: ViewModeling {
    // -- State Definition --
    typealias State = ___VARIABLE_productName:identifier___State
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

extension ___FILEBASENAMEASIDENTIFIER___ViewModel {
    @MainActor
    func currentState() -> State {
        state
    }
}
