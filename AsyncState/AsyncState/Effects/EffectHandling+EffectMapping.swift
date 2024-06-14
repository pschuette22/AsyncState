//
//  EffectHandling+EffectMapping.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/13/24.
//

import Foundation

public protocol EffectMapping: EffectHandling {
    /// Map a given effect to a HandledEffect type
    /// This is where child components map effects pushed down by their parents
    /// - Parameter effect: Generic effect which may be mapped to a handled effect type
    /// - Returns: ``EffectHandling.HandledEffect`` if applicable. nil if unhandled
    func map(_ effect: any Effect) async -> HandledEffect?
}

public extension EffectMapping {
    func map(all effects: [any Effect]) async -> [HandledEffect] {
        await withTaskGroup(of: HandledEffect?.self) { group in
            for effect in effects {
                group.addTask { [weak self] in
                    await self?.map(effect)
                }
            }
            var results = [HandledEffect]()
            for await result in group {
                guard let result else { continue }

                results.append(result)
            }
            return results
        }
    }
}
