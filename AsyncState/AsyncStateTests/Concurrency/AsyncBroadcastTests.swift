//
//  AsyncBroadcastTests.swift
//  AsyncStateTests
//
//  Created by Peter Schuette on 6/2/24.
//

import XCTest
import AsyncState

final class AsyncBroadcastTests: XCTestCase {
    enum TestElement: Hashable, Sendable {
        case some(Int)
        case final
        case error
    }

    private var asyncBroadcast: OpenAsyncBroadcast<TestElement>!

    override func setUpWithError() throws {
        asyncBroadcast = OpenAsyncBroadcast<TestElement>()
    }

    override func tearDownWithError() throws {
        asyncBroadcast = nil
    }
    
    func testObserve_fromSingleStream_receivesValue() async throws {
        let observer = asyncBroadcast.observe()
        
        let task = Task {
            var iterator = observer.makeAsyncIterator()
            while let val = await iterator.next() {
                switch val {
                case .some(let int):
                    return int
                default:
                    break
                }
            }
            return -1
        }
        
        asyncBroadcast.send(.some(11))
        
        let result = await task.value
        XCTAssertEqual(result, 11)
    }
    
    func testObserve_fromMultipleStreams_receivesValueInBothPlaces() async throws {
        let observer1 = asyncBroadcast.observe()
        let observer2 = asyncBroadcast.observe()

        let task1 = Task {
            var iterator = observer1.makeAsyncIterator()
            while let val = await iterator.next() {
                switch val {
                case .some(let int):
                    return int
                default:
                    break
                }
            }
            return -1
        }
        
        let task2 = Task {
            var iterator = observer2.makeAsyncIterator()
            while let val = await iterator.next() {
                switch val {
                case .some(let int):
                    return int
                default:
                    break
                }
            }
            return -1
        }
        
        asyncBroadcast.send(.some(11))
        
        let result1 = await task1.value
        let result2 = await task2.value

        XCTAssertEqual(result1, 11)
        XCTAssertEqual(result1, result2)
    }
    
    func testFinish_withFinalValue_receivesFinalValue() async {
        let observer = asyncBroadcast.observe(final: .final)
        let task = Task<TestElement, Never> {
            var iterator = observer.makeAsyncIterator()
            while let val = await iterator.next() {
                return val
            }
            return .error
        }

        asyncBroadcast.finish()
        let result = await task.value
        XCTAssertEqual(result, .final)
    }
}
