//
//  ViewModeling.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation

public protocol ViewModeling<State>: Stateful, StateStreaming {
  @MainActor
  func currentState() -> State
}

#if canImport(UIKit)

  public extension ViewModeling where State: CollectionViewState {
    typealias Sections = State.Sections
    typealias Items = State.Items
  }

#endif
