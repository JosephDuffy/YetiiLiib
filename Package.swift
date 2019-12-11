// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YetiiLiib",
    products: [
        .library(name: "YetiiLiib", targets: ["YetiiLiib"]),
    ],
    targets: [
        .target(name: "YetiiLiib", dependencies: []),
        .testTarget(name: "YetiiLiibTests", dependencies: ["YetiiLiib"]),
    ]
)
