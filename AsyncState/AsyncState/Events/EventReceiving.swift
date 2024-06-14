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
        _ mapping: @escaping (StreamedEvent) -> HandledEffect?
    ) {
        Task { [weak self] in
            var iterator = eventStreamer.eventStream.observe().makeAsyncIterator()
            while let event = await iterator.next(), let self {
                guard let effect = mapping(event) else { continue }
                self.handle(effect)
            }
        }
    }
}
