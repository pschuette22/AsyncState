//
//  EffectMappingTests.swift
//
//
//  Created by Peter Schuette on 9/29/24.
//

import Foundation
@testable import AsyncState
import XCTest

final class EffectMappingTests: XCTestCase {
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
    func test_mapAllEffects_mapsArrayOfEffects_andHandlesMappableEffects() async {
        
        let handledEffects = await effectHandler.map(all: [
            MockEffect.someMappable(123),
            MockEffect.someUnmappable,
            MockEffect.someMappable(456),
        ])
    
        XCTAssertEqual(
            handledEffects, [MockEffectHandler.HandledEffect.some(123), .some(456)]
        )
    }
}
