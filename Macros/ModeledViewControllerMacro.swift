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
/// intoa
/// ```swift
/// final class SomeViewController: UIViewController {
///    typealias State = VCState
///
///    typealias ViewModel = VCModel
///
///    let viewModel: ViewModel
///
///    private var stateObservingTask: Task<Void, Never>?
///
///    required init(viewModel: ViewModel) {
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
public enum ModeledViewControllerMacro {
    enum ExpansionError: Swift.Error, Equatable {
        case classTypeRequired
        case invalidArguments
        case invalidExpression
    }

    private static func validate(_ declaration: DeclGroupSyntax) throws {
        guard let _ /* classDeclaration */ = declaration.as(ClassDeclSyntax.self) else {
            // This is only supported for class types
            throw ExpansionError.classTypeRequired
        }
        // TODO: validate attached types
    }

    private static func extractTypeExpressions(
        from node: AttributeSyntax
    ) throws -> (
        stateExpression: MemberAccessExprSyntax,
        viewModelExpression: MemberAccessExprSyntax
    ) {
        guard case let .argumentList(expressionList) = node.arguments else {
            throw ExpansionError.invalidArguments
        }

        let expressions = expressionList.map { $0 as LabeledExprSyntax }

        guard expressions.count == 2 else {
            throw ExpansionError.invalidArguments
        }

        // Can I convert this to member type expressions?
        guard
            let stateExpression = expressions[0].expression.as(MemberAccessExprSyntax.self),
//            let stateTypeName = stateExpression.base?.description,
            let viewModelExpression = expressions[1].expression.as(MemberAccessExprSyntax.self)
//            let viewModelTypeName = viewModelExpression.base?.description
        else {
            throw ExpansionError.invalidExpression
        }

        return (stateExpression: stateExpression, viewModelExpression: viewModelExpression)
    }
}

// MARK: - ExtensionMacro / Conformances

extension ModeledViewControllerMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo _: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        var result = [ExtensionDeclSyntax]()
        // TODO: validate this is a ViewController
        // TODO: account for protection level (public / package / etc.)
        let modeledViewControllerExtension = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): ModeledViewController { }
            """
        )
        result.append(modeledViewControllerExtension)
        return result
    }
}

// MARK: - MemberMacro / Added properties

extension ModeledViewControllerMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        try validate(declaration)
        let (stateExpression, viewModelExpression) = try extractTypeExpressions(from: node)

        guard
            let stateTypeName = stateExpression.base?.description,
            let viewModelTypeName = viewModelExpression.base?.description
        else {
            throw ExpansionError.invalidExpression
        }
        var result = [DeclSyntax]()

        result.append("typealias State = \(raw: stateTypeName)")
        result.append("typealias ViewModel = \(raw: viewModelTypeName)")
        // TODO: account for public / package type
        result.append("private var stateObservingTask: Task<Void, Never>?")
        result.append("let viewModel: ViewModel")
        result.append(
            """
            required init(viewModel: ViewModel) {
                self.viewModel = viewModel

                super.init(nibName: nil, bundle: nil)
            }

            @available(*, unavailable, message: "Storyboards are not supported. Use init(viewModel:)")
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            /// Start an asynchronous Task which receives state changes and renders them
            @MainActor
            private func startObservingState(renderImmediately: Bool = false) {
                guard stateObservingTask?.isCancelled != false else {
                    // already observing
                    return
                }

                let stateStream = viewModel.stateStream.observe()
                stateObservingTask = Task { [weak self] in
                    if renderImmediately {
                        await self?.renderCurrentState()
                    }

                    var stateIterator = stateStream.makeAsyncIterator()
                    while let newState = await stateIterator.next() {
                        await self?.render(newState)
                    }
                }
            }

            /// Retrieve the current state from the ViewModel and render
            func renderCurrentState() async {
                let currentState = await viewModel.currentState()
                await render(currentState)
            }

            /// Stop observing state changes
            @MainActor
            private func stopObservingState() {
                stateObservingTask?.cancel()
                stateObservingTask = nil
            }
            """
        )

        // TODO: append required initializer with view model

        return result
    }
}
