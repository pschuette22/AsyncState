//
//  Stateful.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol Stateful<State> {
    associatedtype State: ObjectState
}
