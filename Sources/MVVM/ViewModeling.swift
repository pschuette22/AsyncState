//
//  ViewModeling.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation

public protocol ViewModeling<State>: Stateful, StateStreaming {
    func currentState() async -> State
}
