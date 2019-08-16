// swift-tools-version:4.2
import PackageDescription
let package = Package(
    name: "jupyterInstalledPackages",
    products: [
        .library(
            name: "jupyterInstalledPackages",
            type: .dynamic,
            targets: ["jupyterInstalledPackages"]),
    ],
    dependencies: [.package(url: "https://github.com/mxcl/Path.swift", from: "0.16.1"),
],
    targets: [
        .target(
            name: "jupyterInstalledPackages",
            dependencies: ["Path",
],
            path: ".",
            sources: ["jupyterInstalledPackages.swift"]),
    ])
