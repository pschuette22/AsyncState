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
  named(startObservingState(renderImmediately:)),
  named(stopObservingState),
  named(currentState)
)
@attached(extension, conformances: ModeledViewController)
public macro Modeled<State: ObjectState, ViewModel: ViewModeling>(_: State.Type, _: ViewModel.Type) = #externalMacro(
  module: "AsyncStateMacros",
  type: "ModeledViewControllerMacro"
)

@attached(
  member,
  names:
  named(State),
  named(ViewModel),
  named(viewModel),
  named(stateObservingTask),
  named(startObservingState(renderImmediately:)),
  named(stopObservingState),
  named(currentState)
)
@attached(extension, conformances: ModeledViewController)
public macro Modeled<State: ObjectState, ViewModel>(_: State.Type, interface: ViewModel) = #externalMacro(
  module: "AsyncStateMacros",
  type: "ModeledViewControllerMacro"
)

#if canImport(UIKit)
  public protocol ModeledViewController<State, ViewModel>: StateRendering, UIViewController where ViewModel: ViewModeling, ViewModel.State == State {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
  }

  public extension ModeledViewController where State: CollectionViewState {
    typealias Sections = State.Sections
    typealias Items = State.Items
  }

#else
  @available(*, deprecated, message: "This is a test-only implementation. It is intended to be used with a UIViewController subclass")
  public protocol ModeledViewController<State, ViewModel>: AnyObject, StateRendering where ViewModel: ViewModeling, ViewModel.State == State {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
  }
#endif
