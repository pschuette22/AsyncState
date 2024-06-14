//
//  EventReceiving.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol EventReceiving: EffectHandling {}

extension EventReceiving {
    /// Receive ``Event``s from a streaming object and translate them into ``Effect``s
    /// - Parameters:
    ///   - eventStreamer: Object streaming ``Event``s
    ///   - effectMapping: ``Effect`` these events have
    func receive<ReceivedEvent>(
        from eventStreamer: some EventStreaming<ReceivedEvent>,
        _ effectMapping: @escaping (ReceivedEvent) -> [HandledEffect]
    ) {
        Task { [weak self, weak eventStreamer] in
            guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
            while let event = await iterator.next() {
                let effects = effectMapping(event)
                if effects.isEmpty { continue }
                self?.handle(all: effects)
            }
        }
    }
}

extension EventReceiving where Self: EventStreaming {
    func receive<ReceivedEvent>(
        from eventStreamer: some EventStreaming<ReceivedEvent>,
        rebroadcasting eventMapping: @escaping (ReceivedEvent) -> StreamedEvent?,
        _ effectMapping: @escaping (ReceivedEvent) -> [HandledEffect]
    ) {
        Task { [weak self, weak eventStreamer] in
            guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
            while let event = await iterator.next() {
                //
                if let rebroadcasted = eventMapping(event) {
                    // This is a little funky. Should we keep the send function open?
                    (self?.eventStream as? OpenAsyncBroadcast<StreamedEvent>)?.send(rebroadcasted)
                }

                let effects = effectMapping(event)
                if !effects.isEmpty {
                    self?.handle(all: effects)
                }
            }
        }
    }
}
