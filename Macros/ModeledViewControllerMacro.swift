//
//  File.swift
//  
//
//  Created by Peter Schuette on 6/19/24.
//

#if canImport(UIKit)
import Foundation
import UIKit
import AsyncState
import SwiftSyntaxMacros

public struct ModeledViewControllerMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        []
    }
}
#endif
