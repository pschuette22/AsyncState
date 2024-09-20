//
//  AggregateEventReducer.swift
//
//
//  Created by Peter Schuette on 9/19/24.
//

import Foundation

public class AggregateEventReducer<SomeState: ObjectState> {
    public private(set) var reducers = [any EventReducer]()
    
    public init(reducers: [any EventReducer] = [any EventReducer]()) {
        self.reducers = reducers
    }
    
    public func reduce<Outgoing: Effect>(
        _ event: any Event,
        for state: some ObjectState,
        into effects: inout [Outgoing]
    ) {
        for reducer in reducers {
            reducer.reduce(event, for: state, into: &effects)
        }
    }
}
