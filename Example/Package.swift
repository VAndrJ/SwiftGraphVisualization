// swift-tools-version:5.9

import PackageDescription

let settings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
    name: "SwiftGraphVisualization",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftGraphVisualization",
            targets: ["SwiftGraphVisualization"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftGraphVisualization",
            dependencies: [],
            swiftSettings: settings
        ),
    ]
)
