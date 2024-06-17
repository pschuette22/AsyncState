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
