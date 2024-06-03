//
//  State.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol AnyState: Hashable, Sendable {}

public extension AnyState {
    mutating
    func update(_ handler: (inout Self) -> Void) {
        var updated = self
        handler(&updated)
        self = updated
    }
}

public extension AnyState where Self: AnyObject {
    @available(*, deprecated, message: "States should be value types! References break the update paradigm.")
    func update(_: (inout Self) -> Void) {
        assertionFailure("States must be value types!")
    }
}
