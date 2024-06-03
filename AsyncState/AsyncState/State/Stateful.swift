//
//  Stateful.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol Stateful<State> {
    associatedtype State: AnyState
}

public protocol StateStreaming: Stateful {
    var stateStream: any AsyncBroadcast<State> { get }
}

public protocol StateRendering: Stateful {
    @MainActor
    func render(_ state: State)
}

final class SomeObjectState: AnyState, Equatable, Hashable, Sendable {
    static func == (lhs: SomeObjectState, rhs: SomeObjectState) -> Bool {
        lhs.int == rhs.int
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(int)
    }

    let int = 0
}

public class SomeObject {
    var state: SomeObjectState = .init()

    func asdfasdf() {
        state.update { _ in
        }
    }
}
