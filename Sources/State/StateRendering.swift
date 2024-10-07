//
//  StateRendering.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol StateRendering: Stateful {
  @MainActor
  func render(_ state: State)
}

extension StateRendering {
    /// Pass the current  State to ``render(_:)``
    public func renderCurrentState() async {
        let state = await currentState()
        await render(state)
    }
}
