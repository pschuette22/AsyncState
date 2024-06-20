//
//  AsyncStateMacros.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation
import AsyncState
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct AsyncStateMacros: CompilerPlugin {
#if canImport(UIKit)
    fileprivate static let uikitMacros: [Macro.Type] = [
        ModeledViewControllerMacro.self
    ]
#else
    fileprivate static let uikitMacros: [Macro.Type] = []
#endif

    var providingMacros: [Macro.Type] = uikitMacros + []
}
