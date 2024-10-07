//
//  MockEffectHandler.swift
//  
//
//  Created by Peter Schuette on 9/29/24.
//

import Foundation
import AsyncState

@MainActor
final class MockEffectHandler: EffectHandling, EffectMapping {
    var mapping: ((any Effect) -> HandledEffect?)?

    var mappedEffects = [any Effect]()
    var handledEffects = [HandledEffect]()

    enum HandledEffect: Effect {
        case some(Int)
        case someOther(Int)
    }
    
    func handle(_ effect: HandledEffect) async {
        self.handledEffects.append(effect)
    }
    
    func map(_ effect: any AsyncState.Effect) async -> HandledEffect? {
        mappedEffects.append(effect)
        return mapping?(effect)
    }
    
    func setMapping(_ mapping: @escaping ((any Effect) -> HandledEffect?)) {
        self.mapping = mapping
    }
}

