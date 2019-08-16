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
.package(url: "https://github.com/saeta/Just", from: "0.7.2"),
.package(url: "https://github.com/latenitesoft/NotebookExport", from: "0.5.0"),
],
    targets: [
        .target(
            name: "jupyterInstalledPackages",
            dependencies: ["Path",
"Just",
"NotebookExport",
],
            path: ".",
            sources: ["jupyterInstalledPackages.swift"]),
    ])
