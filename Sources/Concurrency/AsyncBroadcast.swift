//
//  AsyncBroadcast.swift
//  AsyncState
//
//  Created by Peter Schuette on 6/2/24.
//

import Foundation

public protocol AsyncBroadcast<Element> {
  associatedtype Element: Sendable

  func observe() -> AsyncStream<Element>
  func observe(final: Element?) -> AsyncStream<Element>
}

/// Broadcast asynchronously to a group of subscribers
public final class OpenAsyncBroadcast<Element: Sendable>: AsyncBroadcast {
  private let lock = NSLock()

  public private(set) var didFinish: Bool = false
  private var continuations = [UUID: (AsyncStream<Element>.Continuation, Element?)]()

  public init() {}

  public func erased() -> any AsyncBroadcast<Element> {
    self
  }

  public func send(_ element: Element) {
    lock.lock()
    let continuations = continuations
    lock.unlock()

    for (id, (continuation, _)) in continuations {
      Task.detached { [weak self] in
        let result = continuation.yield(with: .success(element))
        switch result {
        case .terminated:
          self?.remove(id: id)
        case .dropped, .enqueued:
          break
        @unknown default:
          break
        }
      }
    }
  }

  public func observe() -> AsyncStream<Element> {
    observe(final: nil)
  }

  public func observe(final: Element?) -> AsyncStream<Element> {
    AsyncStream { [weak self] continuation in
      guard let id = self?.add(continuation: continuation, final: final) else {
        continuation.finish()
        return
      }
      continuation.onTermination = { [weak self] _ in
        self?.remove(id: id)
      }
    }
  }

  public func finish() {
    lock.lock()
    didFinish = true
    let continuations = continuations.values
    self.continuations.removeAll()
    lock.unlock()

    for (continuation, finalElement) in continuations {
      Task.detached {
        if let finalElement {
          continuation.yield(with: .success(finalElement))
        }
        continuation.finish()
      }
    }
  }

  private func add(continuation: AsyncStream<Element>.Continuation, final: Element?) -> UUID? {
    lock.lock()
    defer { lock.unlock() }

    guard !didFinish else { return nil }
    let id = UUID()
    continuations.updateValue((continuation, final), forKey: id)
    return id
  }

  private func remove(id: UUID) {
    lock.lock()
    continuations.removeValue(forKey: id)
    lock.unlock()
  }

  deinit {
    finish()
  }
}
