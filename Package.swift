// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CodableAI",
    platforms: [
        .iOS(.v15)  // <-- Set minimum iOS version to 15.0 or higher
    ],
    products: [
        .library(
            name: "CodableAI",
            targets: ["CodableAI"]),
    ],
    targets: [
        .target(
            name: "CodableAI",
            path: "CodableAI"),
        .testTarget(
            name: "CodableAITests",
            dependencies: ["CodableAI"],
            path: "CodableAITests"),
    ]
)
