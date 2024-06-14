//
//  EventReceiving.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol EventReceiving: EffectHandling {}

extension EventReceiving {
    func receive<StreamedEvent>(
        eventsFrom eventStreamer: some EventStreaming<StreamedEvent>,
        _ mapping: @escaping (StreamedEvent) -> [HandledEffect]
    ) {
        Task { [weak self, weak eventStreamer] in
            guard var iterator = eventStreamer?.eventStream.observe().makeAsyncIterator() else { return }
            while let event = await iterator.next() {
                let effects = mapping(event)
                if effects.isEmpty { continue }
                self?.handle(all: effects)
            }
        }
    }
}
