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

public extension EffectHandling {
  // Default implementation. Callers may implement this to handle batches of effects together
  func handle(all effects: [HandledEffect]) {
    for effect in effects {
      handle(effect)
    }
  }
}

extension EffectHandling where Self: EffectMapping {
  /// Handle some ``Effect`` if it can be mapped to a ``HandledEffect``
  /// If the ``Effect`` is not mapped, it will be ignored.
  /// - Parameter effect: Any ``Effect`` which may or may not be mapped
  func handleIfNeeded<SomeEffect: Effect>(_ effect: SomeEffect) {
    assert(
      SomeEffect.self != HandledEffect.self,
      "\(effect) does not need to be mapped, was this called in error?"
    )

    Task { [weak self] in
      guard let mappedEffect = await self?.map(effect) else { return }

      self?.handle(mappedEffect)
    }
  }

  /// Handle a batch of ``Effect``s if they can be mapped. ``Effect``s which are not mapped will be ignored.
  /// - Parameter effects: ``Array`` of ``Effect``s which may or may not be mapped to a ``HandledEffect``
  func handleIfNeeded(_ effects: [any Effect]) {
    Task { [weak self] in
      guard let mappedEffects = await self?.map(all: effects) else { return }

      self?.handle(all: mappedEffects)
    }
  }
}
