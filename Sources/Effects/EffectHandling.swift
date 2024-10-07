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

  /// Handler declaration for a given effect
  /// - Parameter effect: ``Effect``
  func handle(_ effect: HandledEffect) async

  /// Handler declaration for a batch of effects received at the same time.
  /// - Parameter effects: ``Array`` of ``Effect``s which are handled by this object
  func handle(all effects: [HandledEffect]) async
}

public extension EffectHandling {
  // Default implementation. Callers may implement this to handle batches of effects simultaneously
  func handle(all effects: [HandledEffect]) async {
    for effect in effects {
      await handle(effect)
    }
  }
}

public extension EffectHandling where Self: EffectMapping {
  /// Handle some ``Effect`` if it can be mapped to a ``HandledEffect``
  /// If the ``Effect`` is not mapped, it will be ignored.
  /// - Parameter effect: Any ``Effect`` which may or may not be mapped
  func handleIfNeeded(_ effect: any Effect) async {
    #if !APPSTORE
    if type(of: effect) == HandledEffect.self {
        NSLog("Passed effect \(effect) is already \(type(of: HandledEffect.self)) and doesn't need to be mapped. Was this called in error?")
    }
    #endif
    guard let mappedEffect = await map(effect) else { return }

    await handle(mappedEffect)
  }

  /// Handle a batch of ``Effect``s if they can be mapped. ``Effect``s which are not mapped will be ignored.
  /// - Parameter effects: ``Array`` of ``Effect``s which may or may not be mapped to a ``HandledEffect``
  func handleIfNeeded(_ effects: [any Effect]) async {
      let mappedEffects = await map(all: effects)

      await handle(all: mappedEffects)
  }
}
