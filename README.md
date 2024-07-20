# AsyncState
Manage Swift app state asynchronously.

- [Summary](#summary)
- [Installation](#installation)
- [Usage](#usage)

### Summary
The async state framework simplifies swift object state management. It encourages single responsibility principles and state encapsulation. It was designed to be used in a stateful Model View ViewModel architecture, standard for iOS application development with UIKit.

### Installation
Async State is distributed via Swift Package Manager. Add the following to your `Package.swift` or via XCode SPM manager.

```swift
  ...
  dependencies: [
    .package(url: "https://github.com/pschuette22/async-state", from: "1.0.0"),
  ],
  .target(
    ...
    dependencies: [
      .product(name: "AsyncState", package: "async-state"),
      .product(name: "AsyncStateMacros", package: "async-state"),
    ],
  ),
```

### Usage

Async State comes with three major building blocks and helpers for each type. These building blocks are Events, Effects, and State.

#### Events
Events are emitted from an object when something occurs. This could be a tap action, a system event, or anything that a programmer would like their feature to react to. These events are broadcast "vertically". Event broadcasters do not track the progress of an event nor do they care who receives them. They tell the world something happened and move on.

An object which sends events conforms to `EventStreaming`.

#### Effects
Effects are the result of events. When an object receives an event AsyncState provides helpers for mapping these events to effects. This paradigm encourages compile safety. Effects may be "pushed" to child objects. The pushed effects are first mapped to the receiving childs effect type. 

#### State
TODO: Talk about state paradigm

### Templates
Install templates using the install script. Navigate to the 