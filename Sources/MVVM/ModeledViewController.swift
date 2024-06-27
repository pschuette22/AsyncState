//
//  ModeledViewController.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//
import Foundation
import SwiftSyntaxMacros
#if canImport(UIKit)
    import UIKit
#endif

@attached(
    member,
    names:
        named(State),
        named(ViewModel),
        named(viewModel),
        named(stateObservingTask),
        named(init(viewModel:)),
        named(init(coder:)),
        named(startObservingState(renderImmediately:)),
        named(renderCurrentState),
        named(stopObservingState)
)
@attached(extension, conformances: ModeledViewController)
public macro Modeled<State: ObjectState, ViewModel: ViewModeling>(_: State.Type, _: ViewModel.Type) = #externalMacro(
    module: "AsyncStateMacros",
    type: "ModeledViewControllerMacro"
)

#if canImport(UIKit)
    public protocol ModeledViewController<State, ViewModel>: StateRendering, UIViewController {
        associatedtype ViewModel: ViewModeling<State>
        var viewModel: ViewModel { get }
    }

    extension ModeledViewController {
        /// Retrieve the current state from the ViewModel and render
        public func renderCurrentState() async {
            let currentState = await viewModel.currentState()
            await render(currentState)
        }
    }
#else
    @available(*, deprecated, message: "This is a test-only implementation. It is intended to be used with a UIViewController subclass")
    public protocol ModeledViewController<State, ViewModel>: AnyObject, StateRendering {
        associatedtype ViewModel: ViewModeling<State>
        var viewModel: ViewModel { get }

        func renderCurrentState() async
        func startObservingState(renderImmediately: Bool)
    }
#endif
