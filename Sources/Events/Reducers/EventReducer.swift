//
//  EventReducer.swift
//
//
//  Created by Peter Schuette on 9/19/24.
//

import Foundation

public protocol EventReducer {
    func reduce<Incoming: Event, State: ObjectState, Outgoing: Effect>(
        _ event: Incoming,
        for state: State,
        into effects: inout [Outgoing]
    )
}

public extension EventReducer {
    func reduce<Incoming: Event, Outgoing: Effect>(_ event: Incoming, into effects: inout [Outgoing]) {
        reduce(event, for: Empty.state, into: &effects)
    }
}
