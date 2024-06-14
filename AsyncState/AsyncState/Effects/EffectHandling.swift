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
    /// - Parameter effect: ``Effect``
    func handle(_ effect: HandledEffect)

    /// Handler declaration for a batch of effects received at the same time.
    /// - Parameter effects: ``Array`` of ``Effect``s which are handled by this object
    func handle(all effects: [HandledEffect])
}

extension EffectHandling where Self: EffectMapping {
    func handleIfNeeded(_ effect: any Effect) {
        Task { [weak self] in
            guard let mappedEffect = await self?.map(effect) else { return }

            self?.handle(mappedEffect)
        }
    }

    func handleIfNeeded(_ effects: [any Effect]) {
        Task { [weak self] in
            guard let mappedEffects = await self?.map(all: effects) else { return }

            self?.handle(all: mappedEffects)
        }
    }
}
