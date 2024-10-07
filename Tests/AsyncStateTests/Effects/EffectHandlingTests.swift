//
//  EffectHandlingTests.swift
//
//
//  Created by Peter Schuette on 9/27/24.
//

import Foundation
@testable import AsyncState
import XCTest

final class EffectHandlingTests: XCTestCase {
    enum MockEffect: Effect {
        case someMappable(Int)
        case someUnmappable
    }

    private var effectHandler: MockEffectHandler!

    override func setUp() async throws {
        effectHandler = await .init()
        await setupEffectHandlerMapping()
    }

    @MainActor
    private func setupEffectHandlerMapping() async {
        effectHandler.mapping = { effect in
            guard let effect = effect as? MockEffect else { return nil }

            return switch effect {
            case let .someMappable(value): .some(value)
            case .someUnmappable: nil
            }
        }
    }

    override func tearDown() {
        effectHandler = nil
    }

    @MainActor
    func test_handleIfNeeded_mapsEffect_andHandlesMappedEffect() async {

        await effectHandler.handleIfNeeded(MockEffect.someMappable(123))
        XCTAssert(
            effectHandler.mappedEffects.contains(where: { ($0 as? MockEffect) == .someMappable(123)})
        )
    }

    @MainActor
    func test_handleIfNeeded_ignoresUnmappedEffects() async {

        await effectHandler.handleIfNeeded(MockEffect.someMappable(123))
        await effectHandler.handleIfNeeded(MockEffect.someUnmappable)

        XCTAssert(
            effectHandler.mappedEffects.contains(
                where: { ($0 as? MockEffect) == .someUnmappable }
            )
        )
        XCTAssert(
            effectHandler.mappedEffects.contains(
                where: { ($0 as? MockEffect) == .someMappable(123) }
            )
        )
    }

    @MainActor
    func test_handleAllIfNeeded_mapsEffects_andHandlesMappedEffects() async {
        await effectHandler.handleIfNeeded([
            MockEffect.someMappable(123),
            MockEffect.someMappable(123),
            MockEffect.someMappable(123)
        ])

        XCTAssertEqual(effectHandler.mappedEffects.count, 3)
    }

}
