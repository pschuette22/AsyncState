//
//  StateStreaming.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol StateStreaming: Stateful {
    var stateStream: any AsyncBroadcast<State> { get }
}
