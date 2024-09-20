//
//  EventReceiving.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol EventReceiving: EffectHandling {
  associatedtype ReceivedEvent: Event

  func effects(of event: ReceivedEvent) -> [HandledEffect]
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
          let mappedEvent = await eventMapping(event),
          let effects = self?.effects(of: mappedEvent)
        else { continue }
        self?.handle(all: effects)
      }
    }
  }
}

public extension EventReceiving where Self: EventStreaming {
  func receiveEvents<ReceivedEvent>(
    from eventStreamer: some EventStreaming<ReceivedEvent>,
    rebroadcasting eventMapping: @escaping (ReceivedEvent) -> StreamedEvent?,
    effectMapping: @escaping (ReceivedEvent) -> [HandledEffect]
  ) {
    Task { [weak self, weak eventStreamer] in
      guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
      while let event = await iterator.next(), let self {
        //
        if let rebroadcasted = eventMapping(event) {
          // This is a little funky. Should we keep the send function open?
          (eventStream as? OpenAsyncBroadcast<StreamedEvent>)?.send(rebroadcasted)
        }

        let effects = effectMapping(event)
        if !effects.isEmpty {
          handle(all: effects)
        }
      }
    }
  }
}
