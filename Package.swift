// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "async-state",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "AsyncState", targets: ["AsyncState"]),
//        .library(name: "AsyncStateMacros", targets: ["AsyncStateMacros"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-syntax", .upToNextMajor(from: "510.0.2")),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", .upToNextMajor(from: "0.4.1")),
    ],
    targets: [
        .macro(
            name: "AsyncStateMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Macros"
        ),
        .target(
            name: "AsyncState",
            dependencies: [
                "AsyncStateMacros",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AsyncStateTests",
            dependencies: [
                "AsyncState"
            ],
            path: "Tests/AsyncStateTests"
        ),
        .testTarget(
            name: "AsyncStateMacrosTests",
            dependencies: [
                "AsyncState",
                "AsyncStateMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ],
            path: "Tests/AsyncStateMacrosTests"
        )
    ]
)
