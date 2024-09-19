// ___FILEHEADER___

import AsyncState
import Foundation

protocol ___VARIABLE_productName:identifier___ViewModelProtocol: ViewModeling where State == ___VARIABLE_productName:identifier___State {

}

final class ___FILEBASENAME___: ___VARIABLE_productName:identifier___ViewModelProtocol {
    // -- State Definition --
    typealias State = ___VARIABLE_productName:identifier___State
    typealias Sections = State.Sections
    typealias Items = State.Items

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
