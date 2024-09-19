// ___FILEHEADER___

import AsyncState
import Foundation

final class ___FILEBASENAMEASIDENTIFIER___: ViewModeling {
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

extension ___FILEBASENAMEASIDENTIFIER___ {
    @MainActor
    func currentState() -> State {
        state
    }
}
