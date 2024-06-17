//
//  State.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol AnyState: Sendable, Hashable {}

public extension AnyState {
    /// Update a state in place. All changes in the update handler will be delivered at once
    /// - Parameter handler: function block handling state changes. Executes synchonrously
    mutating func update(_ handler: (inout Self) -> Void) {
        var updated = self
        handler(&updated)
        self = updated
    }

    /// Apply a set of effects that mutate the state.
    /// State changes of each effect will be applied in the order they are received
    /// - Parameter effects: ``Array`` of ``StateMutatingEffect``s that change a state
    mutating func apply(
        _ effects: [some StateMutatingEffect<Self>]
    ) {
        update { state in
            for effect in effects {
                effect.apply(to: &state)
            }
        }
    }
}

/**
 * Adds extension warnings when AnyState is used on an Object type
 * States should always be distinct value types
 */
public extension AnyState where Self: AnyObject {
    // This isn't a great use of deprecated, but it lifts the warning
    @available(*, deprecated, message: "States should be value types! References break the update paradigm.")
    func update(_: (inout Self) -> Void) {
        assertionFailure("States must be value types! References break the update paradigm.")
    }
}
