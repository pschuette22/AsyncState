//
//  ModeledViewControllerMacroTests.swift
//
//
//  Created by Peter Schuette on 6/23/24.
//

import AsyncState
import AsyncStateMacros
import Foundation
import SwiftSyntaxMacrosTestSupport
import XCTest

final class ModeledViewControllerMacroTests: XCTestCase {
  func testExpand_internalViewController() throws {
    assertMacroExpansion(
      """
      @Modeled(SomeState.self, SomeViewModel.self)
      final class SomeViewController: UIViewController {
          private let someExistingInt: Int
      }
      """,
      expandedSource:
      """
      final class SomeViewController: UIViewController {
          private let someExistingInt: Int

          typealias State = SomeState

          typealias ViewModel = SomeViewModel

          private var stateObservingTask: Task<Void, Never>?

          let viewModel: ViewModel

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
      }

      extension SomeViewController: ModeledViewController {
      }
      """,
      macros: ["Modeled": ModeledViewControllerMacro.self]
    )
  }

  func testExpand_withInterfaceDrivenViewModel_internalViewController() throws {
    assertMacroExpansion(
      """
      @Modeled(SomeState.self, interface: ViewModelProtocol.self)
      final class SomeViewController<ViewModel: ViewModelProtocol>: UIViewController {
          private let someExistingInt: Int
      }
      """,
      expandedSource:
      """
      final class SomeViewController<ViewModel: ViewModelProtocol>: UIViewController {
          private let someExistingInt: Int

          typealias State = SomeState

          private var stateObservingTask: Task<Void, Never>?

          let viewModel: ViewModel

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
      }

      extension SomeViewController: ModeledViewController {
      }
      """,
      macros: ["Modeled": ModeledViewControllerMacro.self]
    )
  }
}

// MARK: - Sample classes

private struct SomeState: ObjectState {
  let someInt: Int
}

private protocol ViewModelProtocol: ViewModeling where State == SomeState {}

private final class SomeViewModel: ViewModelProtocol {
  // TODO: Mock async broadcast
  let stateStream: any AsyncBroadcast<SomeState> = OpenAsyncBroadcast<SomeState>()

  private var state: SomeState = .init(someInt: 123)

  @MainActor
  func currentState() -> SomeState {
    state
  }
}
