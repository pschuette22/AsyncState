//
//  State.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol AnyState: Hashable, Sendable {}

public extension AnyState {
    /// Update a state in place. All changes in the update handler will be delivered at once
    /// - Parameter handler: function block handling state changes. Executes synchonrously
    mutating func update(_ handler: (inout Self) -> Void) {
        var updated = self
        handler(&updated)
        self = updated
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
