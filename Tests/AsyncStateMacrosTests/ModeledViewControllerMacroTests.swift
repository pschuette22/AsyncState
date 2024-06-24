//
//  ModeledViewControllerMacroTests.swift
//
//
//  Created by Peter Schuette on 6/23/24.
//

import Foundation
import XCTest
import MacroTesting
import AsyncState
import AsyncStateMacros

final class ModeledViewControllerMacroTests: XCTestCase {
    override func invokeTest() {
      withMacroTesting(
        macros: ["Modeled": ModeledViewControllerMacro.self]
      ) {
        super.invokeTest()
      }
    }
    
    func test_nothing() {
        XCTAssertEqual(1 + 2, 3)
    }
}
