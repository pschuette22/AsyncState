//
//  Stateful.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol Stateful<State> {
    associatedtype State: AnyState
}

public protocol StateStreaming: Stateful {
    var stateStream: any AsyncBroadcast<State> { get }
}

public protocol StateRendering: Stateful {
    @MainActor
    func render(_ state: State)
}
