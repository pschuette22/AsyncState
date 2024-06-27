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

private final class SomeViewModel: ViewModeling {
    typealias State = SomeState

    // TODO: Mock async broadcast
    let stateStream: any AsyncBroadcast<SomeState> = OpenAsyncBroadcast<SomeState>()

    private var state: SomeState = .init(someInt: 123)

    func currentState() async -> SomeState {
        state
    }
}
