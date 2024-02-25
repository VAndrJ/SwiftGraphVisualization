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
    targets: [
        .target(
            name: "SwiftGraphVisualization",
            path: "SwiftGraphVisualization/Classes",
            swiftSettings: settings
        ),
    ]
)
