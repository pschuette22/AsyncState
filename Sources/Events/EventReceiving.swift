//
//  EventReceiving.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol EventReceiving: EffectHandling {
  associatedtype ReceivedEvent: Event
  associatedtype State: ObjectState

  var eventReducer: any EventReducer<State, HandledEffect> { get }

  func didReceive(_ event: ReceivedEvent) async
}

public extension EventReceiving where State == Empty {
  func didReceive(_ event: ReceivedEvent) async {
    var effects = [HandledEffect]()
    eventReducer.reduce(event, for: Empty.state, into: &effects)
    handle(all: effects)
  }
}

public extension EventReceiving where Self: Stateful {
  func didReceive(_ event: ReceivedEvent) async {
    var effects = [HandledEffect]()
    let currentState = await currentState()
    eventReducer.reduce(event, for: currentState, into: &effects)
    handle(all: effects)
  }
}

public extension EventReceiving {
  /// Receive ``Event``s from a streaming object and translate them into ``Effect``s
  /// - Parameters:
  ///   - eventStreamer: Object streaming ``Event``s
  ///   - effectMapping: ``Effect`` these ``Event``s have
  func receiveEvents<StreamedEvent: Event>(
    from eventStreamer: some EventStreaming<StreamedEvent>,
    as eventMapping: @escaping (StreamedEvent) async -> ReceivedEvent?
  ) {
    Task { [weak self, weak eventStreamer] in
      guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
      while let event = await iterator.next() {
        guard
          let mappedEvent = await eventMapping(event)
        else { continue }
        await self?.didReceive(mappedEvent)
      }
    }
  }
}
