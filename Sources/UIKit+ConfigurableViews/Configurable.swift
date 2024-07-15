//
//  Configurable.swift
//
//
//  Created by Peter Schuette on 6/27/24.
//

#if canImport(UIKit)
  import Foundation
  import UIKit

  public protocol ViewConfiguration: Sendable, Hashable {}

  public protocol Configurable: UIView {
    associatedtype Configuration: ViewConfiguration

    func apply(_ configuration: Configuration)
  }

#endif
