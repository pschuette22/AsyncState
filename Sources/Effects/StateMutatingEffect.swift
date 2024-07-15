//
//  StateMutatingEffect.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/13/24.
//

import Foundation

/// Effects that result in a change of state are state mutating.
public protocol StateMutatingEffect<State>: Effect {
  associatedtype State: ObjectState

  /// Apply the effect to a given state
  /// - Parameter state: State type which is mutated by the effect
  func apply(to state: inout State)
}
