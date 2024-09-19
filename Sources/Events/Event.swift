//
//  Event.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol Event: Sendable, Hashable, CustomStringConvertible {}

public extension Event {
  var description: String {
    String(describing: self)
  }
}
