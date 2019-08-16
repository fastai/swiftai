// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftAI",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(name: "SwiftAI", targets: ["SwiftAI"]),
    ],
  dependencies: [
    .package(url: "https://github.com/saeta/Just", from: "0.7.3"),
    .package(url: "https://github.com/mxcl/Path.swift", from: "0.16.3"),
  ],
  targets: [
    .target( name: "SwiftAI", dependencies: ["Just", "Path"]),
    .target( name: "run", dependencies: ["SwiftAI"]),
  ]
)
