//
//  EventStreaming.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/14/24.
//

import Foundation

public protocol EventStreaming<StreamedEvent>: AnyObject {
  associatedtype StreamedEvent: Event

  var eventStream: any AsyncBroadcast<StreamedEvent> { get }
}
