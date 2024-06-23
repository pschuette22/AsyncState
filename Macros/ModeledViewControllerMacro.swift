//
//  ModeledViewControllerMacro.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct ModeledViewControllerMacro: ExtensionMacro {
    public static func expansion(
        of _: SwiftSyntax.AttributeSyntax,
        attachedTo _: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf _: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo _: [SwiftSyntax.TypeSyntax],
        in _: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        []
    }
}
