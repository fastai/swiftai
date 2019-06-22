// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Harebrain",
    products: [
        .library(name: "Harebrain", targets: ["Harebrain"]),
    ],
  dependencies: [
    .package(url: "https://github.com/saeta/Just", .branch("master")),
    .package(url: "https://github.com/mxcl/Path.swift", .branch("master")),
  ],
  targets: [
    .target( name: "Harebrain", dependencies: ["Just", "Path"]),
    .target( name: "run", dependencies: ["Harebrain"]),
  ]
)
