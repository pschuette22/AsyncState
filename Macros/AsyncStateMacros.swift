//
//  AsyncStateMacros.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AsyncStateMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        ModeledViewControllerMacro.self,
    ]
}
