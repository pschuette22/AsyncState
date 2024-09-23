//
//  EventReducer.swift
//
//
//  Created by Peter Schuette on 9/19/24.
//

import Foundation

public protocol EventReducer<State, Outgoing>: Sendable {
  associatedtype Incoming: Event
  associatedtype State: ObjectState
  associatedtype Outgoing: Effect

  func reduce(
    event: Incoming,
    for state: State,
    into effects: inout [Outgoing]
  )
}

public extension EventReducer {
  func reduce(
    _ event: any Event,
    for state: State,
    into effects: inout [Outgoing]
  ) {
    guard let incoming = event as? Incoming else { return }

    reduce(event: incoming, for: state, into: &effects)
  }
}

public extension EventReducer where State == Empty {
  func reduce(_ event: Incoming, into effects: inout [Outgoing]) {
    reduce(event: event, for: Empty.state, into: &effects)
  }
}
