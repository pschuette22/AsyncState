//
//  ModeledViewControllerMacroTests.swift
//
//
//  Created by Peter Schuette on 6/23/24.
//

import Foundation
import XCTest
import SwiftSyntaxMacrosTestSupport
import AsyncState
import AsyncStateMacros

final class ModeledViewControllerMacroTests: XCTestCase {
    func testExpand() throws {
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
            }
            """,
            macros: ["Modeled": ModeledViewControllerMacro.self]
        )
    }
    
//    func testExpand_onValueType_throwsError throws {
////        assert
//    }
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
