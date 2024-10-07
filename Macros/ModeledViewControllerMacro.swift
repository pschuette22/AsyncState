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
///     private let someExistingInt: Int
///
///     typealias State = SomeState
///
///     typealias ViewModel = SomeViewModel
///
///     private var stateObservingTask: Task<Void, Never>?
///
///     let viewModel: ViewModel
///
///     /// Start an asynchronous Task which receives state changes and renders them
///     @MainActor
///     private func startObservingState(renderImmediately: Bool = false) {
///         guard stateObservingTask?.isCancelled != false else {
///             // already observing
///             return
///         }
///
///         let stateStream = viewModel.stateStream.observe()
///         stateObservingTask = Task { [weak self] in
///             if renderImmediately {
///                 await self?.renderCurrentState()
///             }
///             var stateIterator = stateStream.makeAsyncIterator()
///             while let newState = await stateIterator.next(), let self {
///                 self.render(newState)
///             }
///         }
///     }
///
///     /// Stop observing state changes
///     @MainActor
///     private func stopObservingState() {
///         stateObservingTask?.cancel()
///         stateObservingTask = nil
///     }
///
///     /// Retrieve the current controller state
///     func currentState() async -> State {
///         await viewModel.currentState()
///     }
/// }
///
/// extension SomeViewController: ModeledViewController {
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
    viewModelExpression: MemberAccessExprSyntax,
    isViewModelInterface: Bool
  ) {
    guard case let .argumentList(expressionList) = node.arguments else {
      throw ExpansionError.invalidArguments
    }

    let expressions = expressionList.map { $0 as LabeledExprSyntax }

    guard expressions.count == 2 else {
      throw ExpansionError.invalidArguments
    }

    guard
      let stateExpression = expressions[0].expression.as(MemberAccessExprSyntax.self),
      let viewModelExpression = expressions[1].expression.as(MemberAccessExprSyntax.self)
    else {
      throw ExpansionError.invalidExpression
    }

    let isViewModelInterface = expressions[1].label?.text == "interface"
    return (
      stateExpression: stateExpression,
      viewModelExpression: viewModelExpression,
      isViewModelInterface: isViewModelInterface
    )
  }
}

// MARK: - ExtensionMacro / Conformances

extension ModeledViewControllerMacro: ExtensionMacro {
  public static func expansion(
    of _: AttributeSyntax,
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
    let (stateExpression, viewModelExpression, isViewModelInterface) = try extractTypeExpressions(from: node)

    guard
      let stateTypeName = stateExpression.base?.description,
      let viewModelTypeName = viewModelExpression.base?.description
    else {
      throw ExpansionError.invalidExpression
    }
    var result = [DeclSyntax]()

    result.append("typealias State = \(raw: stateTypeName)")
    if !isViewModelInterface {
      result.append("typealias ViewModel = \(raw: viewModelTypeName)")
    }

    // TODO: account for public / package type
    result.append("private var stateObservingTask: Task<Void, Never>?")
    result.append("let viewModel: ViewModel")

    result.append(
      """
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
              while let newState = await stateIterator.next(), let self {
                  self.render(newState)
              }
          }
      }

      /// Stop observing state changes
      @MainActor
      private func stopObservingState() {
          stateObservingTask?.cancel()
          stateObservingTask = nil
      }

      /// Retrieve the current controller state
      func currentState() async -> State {
          await viewModel.currentState()
      }
      """
    )

    return result
  }
}
