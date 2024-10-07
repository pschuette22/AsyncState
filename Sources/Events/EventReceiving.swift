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
    await handle(all: effects)
  }
}

public extension EventReceiving where Self: Stateful {
  func didReceive(_ event: ReceivedEvent) async {
    var effects = [HandledEffect]()
    let currentState = await currentState()
    eventReducer.reduce(event, for: currentState, into: &effects)
    await handle(all: effects)
  }
}

public extension EventReceiving {
  /// Receive ``Event``s from a streaming object and translate them into ``Effect``s
  /// - Parameters:
  ///   - eventStreamer: Object streaming ``Event``s
  ///   - effectMapping: ``Effect`` these ``Event``s have
  @discardableResult
  func receiveEvents<StreamedEvent: Event>(
    from eventStreamer: some EventStreaming<StreamedEvent>,
    as eventMapping: @escaping (StreamedEvent) async -> ReceivedEvent?
  ) -> Task<Void, Never> {
    Task { [weak self, weak eventStreamer] in
      guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
        while let event = await iterator.next(), !Task.isCancelled, let self {
            guard
                let mappedEvent = await eventMapping(event)
            else { continue }
            await self.didReceive(mappedEvent)
        }
    }
  }
    
    @discardableResult
    func receiveEvents<StreamedEvent: Event>(
      from eventStreamer: some EventStreaming<StreamedEvent>
    ) -> Task<Void, Never> where StreamedEvent == ReceivedEvent {
      receiveEvents(from: eventStreamer, as: { $0 })
    }
}
