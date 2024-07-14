//
//  ModeledViewControllerImplementationTests.swift
//
//
//  Created by Peter Schuette on 6/26/24.
//
#if canImport(UIKit)
import AsyncState
import Foundation
import UIKit
import XCTest

struct SimpleViewState: ObjectState {
    var someInt = 0
}

final class SimpleViewModel: ViewModeling {
    typealias State = SimpleViewState

    private var state: State = .init()

    @MainActor
    func currentState() -> SimpleViewState {
        state
    }

    var stateStream: any AsyncState.AsyncBroadcast<SimpleViewState> = OpenAsyncBroadcast<State>()
}

@Modeled(SimpleViewState.self, SimpleViewModel.self)
final class SimpleViewController: UIViewController {
    private(set) var didRender = false
    @MainActor
    func render(_: SimpleViewState) {
        didRender = true
    }
}

final class ModeledViewControllerImplementationTests: XCTestCase {
    @MainActor
    func testSimpleViewController_init() async throws {
        let viewModel = SimpleViewModel()
        let viewController = SimpleViewController(viewModel: viewModel)
        await viewController.renderCurrentState()
        XCTAssertTrue(viewController.didRender)
    }
}
#endif
