//
//  ModeledViewControllerMacro.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Expands a ViewController into an MVVM architecture:
/// ```swift
/// @Modeled(VCState.self, VCModel.self)
/// final class SomeViewController: UIViewController { ...
/// ```
/// into
/// ```swift
/// final class SomeViewController: UIViewController {
///    let viewModel: VCModel
///    private var stateObservingTask: Task?
///
///    required init(viewModel: VCViewModel) {
///      self.viewModel = viewModel
///      self.init(nib: nil, bundle: nil)
///    }
/// }
///
/// extension SomeViewController {
///     /// Start an asynchronous Task which receives state changes and renders them
///     @MainActor
///     private func startObservingState(renderFirst: Bool) {
///         guard stateObservingTask?.isCancelled != false {
///            // already observing
///            return
///         }
///
///        let stateStream = viewModel.stateStream.observe()
///        Task { [weak self] in
///              if renderImmediately {
///                  await self?.renderCurrentState()
///              }
///
///              var stateIterator = stateStream.makeAsyncIterator()
///              while let newState = await stateIterator.next() {
///                  await self?.render(newState)
///              }
///          }
///        }
///      }
///
///      /// Retrieve the current state from the ViewModel and render
///      public func renderCurrentState() async {
///          let currentState = await viewModel.currentState()
///          await render(currentState)
///      }
///
///      /// Renders the current state and observes
///     @MainActor
///     private func stopObservingState() {
///         stateObservingTask?.cancel()
///         stateObservingTask = nil
///     }
/// }
/// ```
public struct ModeledViewControllerMacro {
    enum ExpansionError: Swift.Error, Equatable {
        case classTypeRequired
        case invalidArguments
        case invalidExpression
    }
}

// MARK: - ExtensionMacro / Conformances

extension ModeledViewControllerMacro: ExtensionMacro {
    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingExtensionsOf type: some TypeSyntaxProtocol,
      conformingTo protocols: [TypeSyntax],
      in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        var result = [ExtensionDeclSyntax]()
        // TODO: validate this is a ViewController
        
        return result
//        [
//            ExtensionDeclSyntax(
//                leadingTrivia: <#T##Trivia?#>,
//                <#T##unexpectedBeforeAttributes: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                attributes: <#T##AttributeListSyntax#>,
//                <#T##unexpectedBetweenAttributesAndModifiers: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                modifiers: <#T##DeclModifierListSyntax#>,
//                <#T##unexpectedBetweenModifiersAndExtensionKeyword: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                extensionKeyword: <#T##TokenSyntax#>,
//                <#T##unexpectedBetweenExtensionKeywordAndExtendedType: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                extendedType: <#T##TypeSyntaxProtocol#>,
//                <#T##unexpectedBetweenExtendedTypeAndInheritanceClause: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                inheritanceClause: <#T##InheritanceClauseSyntax?#>,
//                <#T##unexpectedBetweenInheritanceClauseAndGenericWhereClause: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                genericWhereClause: <#T##GenericWhereClauseSyntax?#>,
//                <#T##unexpectedBetweenGenericWhereClauseAndMemberBlock: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                memberBlock: <#T##MemberBlockSyntax#>,
//                <#T##unexpectedAfterMemberBlock: UnexpectedNodesSyntax?##UnexpectedNodesSyntax?#>,
//                trailingTrivia: <#T##Trivia?#>
//            )
//        ]
    }
}

// MARK: - MemberMacro / Added properties

extension ModeledViewControllerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDeclaration = declaration.as(ClassDeclSyntax.self) else {
            // This is only supported for class types
            throw ExpansionError.classTypeRequired
        }
        var result = [DeclSyntax]()

//        if let inheritanceClause = declaration.inheritanceClause {
//            inheritanceClause.inheritedTypes
//        }
        
        guard  case let .argumentList(expressionList) = node.arguments else {
            throw ExpansionError.invalidArguments
        }
        
        let expressions = expressionList.map { $0 as LabeledExprSyntax }
        
        guard expressions.count == 2 else {
            throw ExpansionError.invalidArguments
        }
        
        // Can I convert this to member type expressions?
        guard 
            let stateExpression = expressions[0].expression.as(MemberAccessExprSyntax.self),
            let stateTypeName = stateExpression.base?.description,
            let viewModelExpression = expressions[1].expression.as(MemberAccessExprSyntax.self),
            let viewModelTypeName = viewModelExpression.base?.description
        else {
            throw ExpansionError.invalidExpression
        }
        
        result.append("typealias State = \(raw: stateTypeName)")
        result.append("typealias ViewModel = \(raw: viewModelTypeName)")
//
//        let initializer = try InitializerDeclSyntax("required init(_ viewModel: ViewModel") {
//            
//        }
                        
        return result
    }
}
