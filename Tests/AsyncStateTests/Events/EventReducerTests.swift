//
//  EventReducerTests.swift
//
//
//  Created by Peter Schuette on 10/7/24.
//

import Foundation
@testable import AsyncState
import XCTest

final class EventReducerTests: XCTestCase {
    enum SomeEvent: Event {
        case a(Int)
        case b(Int)
        case c
    }

    enum SomeEffect: Effect {
        case some(Int)
    }

    func test_reduceA_addsSomeEffectToOutgoingEffects() {
        let reducer = TestEventReducer()
        var effects = [TestEventReducer.Outgoing]()
        reducer.reduce(event: .a(123), for: .init(someInt: 0), into: &effects)
        XCTAssertEqual(effects, [.some(123)])
    }

    func test_reduceB_addsTwoEffectsToOutgoingEffects() {
        let reducer = TestEventReducer()
        var effects = [TestEventReducer.Outgoing]()
        reducer.reduce(event: .b(123), for: .init(someInt: 0), into: &effects)
        XCTAssertEqual(effects, [.some(0), .some(123)])
    }

    func test_reduceC_doesNotAddToOutgoingEffects() {
        let reducer = TestEventReducer()
        var effects = [TestEventReducer.Outgoing]()
        reducer.reduce(event: .c, for: .init(someInt: 0), into: &effects)
        XCTAssertEqual(effects, [])
    }

    func test_emptyStateReducer_addsEffectToOutgoingEffects() {
        let reducer = EmptyStateEventReducer()
        var effects = [EmptyStateEventReducer.Outgoing]()
        reducer.reduce(.a(123), into: &effects)
        XCTAssertEqual(effects, [.some(123)])
    }
}

extension EventReducerTests {
    private struct TestEventReducer: EventReducer {
        typealias State = SomeState
        typealias Incoming = SomeEvent
        typealias Outgoing = SomeEffect

        struct SomeState: ObjectState {
            var someInt: Int
        }

        func reduce(event: Incoming, for state: State, into effects: inout [Outgoing]) {
            switch event {
            case let .a(aInt):
                effects.append(.some(aInt))
            case let .b(bInt):
                effects.append(.some(state.someInt))
                effects.append(.some(bInt))
            case .c:
                break
            }
        }
    }

    private struct EmptyStateEventReducer: EventReducer {
        typealias State = Empty
        typealias Incoming = SomeEvent
        typealias Outgoing = SomeEffect

        func reduce(event: Incoming, for state: State, into effects: inout [Outgoing]) {
            switch event {
            case let .a(aInt):
                effects.append(.some(aInt))
            case .b, .c:
                break
            }
        }
    }
}
