//
//  AggregateEventReducer.swift
//  AsyncState
//
//  Created by Peter Schuette on 9/23/24.
//

import Foundation

@available(iOS 16.0.0, *)
public struct AggregateEventReducer<Incoming: Event, State: ObjectState, Outgoing: Effect>: EventReducer {
  private var components = [any EventReducer<State, Outgoing>]()

  public init(_ components: (any EventReducer<State, Outgoing>)...) {
    self.components = components
  }

  public mutating
  func add(subreducer: some EventReducer<State, Outgoing>) {
    components.append(subreducer)
  }

  public func reduce(
    event: Incoming,
    for state: State,
    into effects: inout [Outgoing]
  ) {
    for component in components {
      component.reduce(event, for: state, into: &effects)
    }
  }
}
