//
//  EffectHandling.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/13/24.
//

import Foundation

/// A type which handles an effect.
public protocol EffectHandling<HandledEffect>: AnyObject {
    associatedtype HandledEffect: Effect

    /// Handler declaration for a given effect. This is not called from a specific thread and syncronization is an obligation of the implementer
    /// - Parameter effect: Effect
    func handle(_ effect: HandledEffect)
}

extension EffectHandling where Self: EffectMapping {
    func handleIfNeeded(_ effect: any Effect) {
        Task { [weak self] in
            guard let mappedEffect = await self?.map(effect) else { return }

            self?.handle(mappedEffect)
        }
    }
}
