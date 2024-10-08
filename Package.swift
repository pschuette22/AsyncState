// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

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
    .plugin(name: "AsyncStateTemplateInstaller", targets: ["TemplateInstallerPlugin"]),
    .library(name: "AsyncState", targets: ["AsyncState"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-syntax", .upToNextMajor(from: "510.0.2")),
  ],
  targets: [
    .macro(
      name: "AsyncStateMacros",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ],
      path: "Macros"
    ),
    .plugin(
      name: "TemplateInstallerPlugin",
      capability: .buildTool(),
      dependencies: [],
      path: "Plugins/TemplateInstaller"
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
        "AsyncState",
      ],
      path: "Tests/AsyncStateTests"
    ),
    .testTarget(
      name: "AsyncStateMacrosTests",
      dependencies: [
        "AsyncState",
        "AsyncStateMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ],
      path: "Tests/AsyncStateMacrosTests"
    ),
  ]
)
