//
//  ModeledViewController.swift
//
//
//  Created by Peter Schuette on 6/19/24.
//
#if canImport(UIKit)
import Foundation
import UIKit

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

    /// Renders the current state and observes
    public func startObservingState(renderImmediately: Bool) {
        let stateStream = viewModel.stateStream.observe()
        Task { [weak self] in
            if renderImmediately {
                await self?.renderCurrentState()
            }

            var stateIterator = stateStream.makeAsyncIterator()
            while let newState = await stateIterator.next() {
                await self?.render(newState)
            }
        }
    }
}

#endif
