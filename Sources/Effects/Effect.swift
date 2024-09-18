//
//  Effect.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/13/24.
//

import Foundation

public protocol Effect: Sendable, Hashable, CustomStringConvertible {}

extension Effect {
    public var description: String {
        String(describing: self)
    }
}
